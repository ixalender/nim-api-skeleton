import jester
import httpcore
import libjwt
import strutils
import storage
import logging
import os
import json
import times

import user
import model
import db/sqlitedatabase

const AUTH_HEADER = "authorization"
const AUTH_TYPE = "Bearer"

type
    ForbiddenError* = object of CatchableError

    AuthInfo* = ref object of BaseModel
        token*:     string
        info*:      string
    
    Grant* = ref object of RootObj
        iss*:   string
        exp*:   string
        admin*: bool

proc authUser*(userId: string, userDB: SqliteDataBase): AuthInfo =
    var jwt_obj: ptr jwt_t
    discard jwt_new(addr jwt_obj)
    echo(userDB.type)
    # let dbcont: DataBaseContainer[SqliteDataBase] = newDataBase[SqliteDataBase]()
    let user: UserInfo = userDB.findUser userId
    if user.empty:
        return AuthInfo(empty: true)
    
    discard jwt_set_alg(
        jwt_obj,
        JWT_ALG_HS256,
        cstring(user.uid), # TODO: use secret key
        cint(user.uid.len)
    )

    let exp: Time = times.getTime() + initDuration(seconds = 3600)
    let grant = $ %* Grant(
        iss: userId,
        exp: $exp.toUnix,
        admin: false
    )
    # TODO: check grantResult and throw error
    let grantResult = jwt_add_grants_json(jwt_obj, cstring(grant))

    let token: string = $jwt_encode_str(jwt_obj)
    jwt_free(jwt_obj)

    if not storage.saveData(token, user.uid):
        logging.error("Could not save user data: $1" % osErrorMsg(osLastError()))

    return AuthInfo(token: token, info: "Token has been generated.")

proc parse_token(headerValue: string): string =
    let findStr = AUTH_TYPE & " "
    let startIdx = headerValue.find(findStr)
    headerValue.substr(findStr.len() + startIdx)

proc checkAuth*(userId: string, headers: HttpHeaders): bool =
    if AUTH_HEADER notin headers.table:
        return false
    # TODO: check grant/payload
    let token = parse_token(headers[AUTH_HEADER])
    let res = storage.getData(token)

    var jwt_obj: ptr jwt_t
    let ret = jwt_decode(addr jwt_obj, token, userId, cint(userId.len))
    jwt_free(jwt_obj)

    userId == res and ret == 0

template withAccess*(userId: string, request: Request, actions: typed): void =
    if not checkAuth(userId, request.headers):
        resp Http401,
            $ %* ErrorResponse(
                error: "user.unauthorized",
                message: "Unauthorized request."
            ), CONTENT_TYPE_JSON

    actions
