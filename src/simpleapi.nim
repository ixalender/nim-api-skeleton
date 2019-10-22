import jester
import asyncdispatch
import strtabs
import strutils
import json
import times
import sets
import htmlgen

import auth
import user
import response

routes:
    post "/auth/@userId":
        let authInfo: AuthInfo = authUser @"userId"

        resp Http200, $ %* response.AuthResponse(
            token: authInfo.token,
            message: authInfo.info
            ), CONTENT_TYPE_JSON
    
    get "/users/@userId":
        withAccess(@"userId", request):
            let userInfo: UserInfo = getUser @"userId"

            if isNil userInfo:
                halt Http404, $ %* ErrorResponse(
                    error: "user.not_found",
                    message: "User not found."
                    )

            resp Http200, $ %* UserResponse(
                name: userInfo.name,
                age: userInfo.age,
                email: userInfo.email
                ), CONTENT_TYPE_JSON

runForever()
