import jester
import httpcore
import strutils
import logging
import os
import json
import times

import jwt
import grant
import storage
import ../user
import ../model
import ../db/sqlitedatabase

type
    ForbiddenError* = object of CatchableError

    AuthInfo* = ref object of BaseModel
        token*:     string
        info*:      string

proc authUser*(userId: string, userDB: SqliteDataBase): AuthInfo =
    let user: UserInfo = userDB.findUser userId
    if user.empty:
        return AuthInfo(empty: true)
    # TODO: remove old tokens
    let grant = $ %* newGrant(user.uid)
    let token: string = jwt.generateJWT(user.uid, user.uid, grant) # TODO: use secret key
    if token.len == 0:
        return AuthInfo(empty: true)

    if not storage.saveJwtData(token, grant):
        logging.error("Could not save user data: $1" % osErrorMsg(osLastError()))

    return AuthInfo(token: token, info: "User has been authenticated.")

proc checkAuth*(userId: string, headers: HttpHeaders): bool =
    let jwtToken = jwt.getJwt(headers)
    if jwtToken.len == 0:
        return false

    let storedJwt = storage.getJwtData(jwtToken)
    if storedJwt.len == 0:
        return false
    let userSessionGrant: Grant = json.to(parseJson(storedJwt), Grant)
    if userSessionGrant.iss != userId:
        return false

    let jwtGrants = jwt.parseJwtPayload(jwtToken, userId)
    if jwtGrants.kind == JNull:
        return false

    let grant: Grant = json.to(jwtGrants, Grant)

    times.fromUnix(parseInt grant.exp) > times.getTime() and
    grant.iss == userId

template withAccess*(userId: string, request: Request, actions: typed): void =
    if not checkAuth(userId, request.headers):
        resp Http401,
            $ %* ErrorResponse(
                error: "user.unauthorized",
                message: "Unauthorized request."
            ), CONTENT_TYPE_JSON

    actions
