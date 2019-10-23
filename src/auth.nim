import random
import jester
import httpcore
import libjwt
import strutils

import response

const AUTH_HEADER = "authorization"
const AUTH_TYPE = "Bearer"

type ForbiddenErrorI* = object of CatchableError

type AuthInfo* = ref object of RootObj
    token*:  string
    info*:   string

proc authUser*(usrName: string): AuthInfo =
    var jwt_obj: ptr jwt_t
    discard jwt_new(addr jwt_obj)
    
    discard jwt_set_alg(
        jwt_obj,
        JWT_ALG_HS256,
        cast[cstring](usrName),
        cast[cint](256))

    let token: string = $jwt_encode_str(jwt_obj)
    jwt_free(jwt_obj)

    return AuthInfo(
        token: token,
        info: "Token has been generated."
    )

proc parse_token(headerValue: string): string =
    let findStr = AUTH_TYPE & " "
    let startIdx = find(headerValue, findStr)
    substr(headerValue, findStr.len() + startIdx)

proc checkAuth*(userId: string, headers: HttpHeaders): bool =
    if AUTH_HEADER notin headers.table:
        return false
    
    let token = parse_token(headers[AUTH_HEADER])
    # TODO: check tocken"
    token != "" and userId != ""

template withAccess*(userId: string, request: Request, actions: typed): void =
    if not checkAuth(userId, request.headers):
        resp Http401,
            $ %* ErrorResponse(
                error: "user.forbidden",
                message: "Unauthorized request."
            ), CONTENT_TYPE_JSON

    actions
