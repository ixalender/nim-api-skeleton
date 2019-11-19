import jester
import httpcore
import strutils
import logging
import os
import json
import times

import jwt
import grant
import ../user
import ../model
import ../request
import ../db/database

type
    ForbiddenError* = object of CatchableError

    AuthInfo* = ref object of BaseModel
        token*:     string
        user*:      UserInfo
        info*:      string

var secret {.threadvar.}: string
    
proc jwtSecret*(): string =
    secret
    
proc jwtSecret*(newSecret: string) =
    secret = newSecret

proc authUser*(userId: string): AuthInfo =
    let user: UserInfo = database.instance().findUser(userId)
    if user.empty:
        return AuthInfo(empty: true)

    let grant = $ %* newGrant(user.uid)
    let token: JwtToken = jwt.generateJWT(user.uid, jwtSecret(), grant)

    if token.empty:
        logging.error("Could not save user data: $1" % osErrorMsg(osLastError()))
        return AuthInfo(empty: true)

    return AuthInfo(token: token.value, user: user, info: "User has been authenticated.")

proc checkAuth*(req: request.ApiRequest): UserInfo =
    let jwtToken = jwt.getJwt(req.headers())
    if jwtToken.len == 0:
        return UserInfo(empty: true)

    let jwtGrants = jwt.parseJwtPayload(jwtToken, jwtSecret())
    if jwtGrants.kind == JNull:
        return UserInfo(empty: true)
    
    let grant: Grant = json.to(jwtGrants, Grant)
    let userInfo: UserInfo = database.instance().findUser(grant.iss)

    result =
        if times.fromUnix(parseInt grant.exp) > times.getTime():
            userInfo
        else:
            UserInfo(empty: true)

