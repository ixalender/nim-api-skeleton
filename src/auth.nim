import random
import jester
import httpcore
import libjwt

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

proc checkAuth*(userId: string, params: HttpHeaders): bool =
    if "auth" notin params.table:
        return false

    let token = params["auth"]
    token != "" and userId != ""

template withAccess*(userId: string, request: Request, actions: typed): void =
    if not checkAuth(userId, request.headers):
        halt(Http401,
            $ %* ErrorResponse(
            error: "user.forbidden",
            message: "Unauthorized request."
            ))

    actions
