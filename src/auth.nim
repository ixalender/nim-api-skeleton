import jester
import httpcore
import libjwt
import strutils
import storage
import logging
import os

import user
import model
import db.database
import db.sqlitedatabase

const AUTH_HEADER = "authorization"
const AUTH_TYPE = "Bearer"

type
    ForbiddenError* = object of CatchableError

    AuthInfo* = ref object of BaseModel
        token*:     string
        info*:      string

proc authUser*(userId: string): AuthInfo =
    var jwt_obj: ptr jwt_t
    discard jwt_new(addr jwt_obj)

    let dbcont: DataBaseContainer[SqliteDataBase] = newDataBase[SqliteDataBase]()
    let user: UserInfo = dbcont.db.findUser(userId)
    if user.empty:
        return AuthInfo(empty: true)
    
    discard jwt_set_alg(
        jwt_obj,
        JWT_ALG_HS256,
        cstring(user.uid),
        cint(user.uid.len)
    )

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
