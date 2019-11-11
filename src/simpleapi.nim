import jester
import asyncdispatch
import strtabs
import strutils
import json

import auth
import user
import response

import db/sqlitedatabase
import views/index

routes:
    get "/":
        resp renderMain(renderIndex())

    post "/auth/@userId":
        let authInfo: AuthInfo = auth.authUser(@"userId", newDataBase())

        if authInfo.empty:
            resp Http404, $ %* ErrorResponse(
                error: "user.not_found",
                message: "User not found."
            ), CONTENT_TYPE_JSON

        resp Http200, $ %* response.AuthResponse(
            token: authInfo.token,
            message: authInfo.info
        ), CONTENT_TYPE_JSON
    
    get "/users/@userId":
        withAccess(@"userId", request):
            let dbcont: SqliteDataBase = newDataBase()
            let userInfo: UserInfo = dbcont.findUser @"userId"

            if userInfo.empty:
                halt Http404, $ %* ErrorResponse(
                    error: "user.not_found",
                    message: "User not found."
                )

            resp Http200, $ %* newUserResponse(userInfo), CONTENT_TYPE_JSON

    error Http404:
        resp Http404, $ %* ErrorResponse(
            error: "not.found",
            message: "Url not found."
        ), CONTENT_TYPE_JSON

runForever()
