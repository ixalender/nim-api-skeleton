import random
import jester
import httpcore

type ForbiddenErrorI* = object of CatchableError

type AuthInfo* = ref object of RootObj
    token*:  string
    info*:   string

proc authUser*(usrName: string): AuthInfo =
    var r = initRand(1000)
    return AuthInfo(
        token: $r.next(),
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
