import os
import jester
import asyncdispatch
import strtabs
import strutils
import json

import auth/auth
import user
import response

import db/database
import db/sqlitedatabase
import views/index

auth.jwtSecret(getEnv("JWT_SECRET"))

routes:
    get "/":
        resp renderMain(renderIndex())

    post "/auth/@userId":
        let db: Database = newSqliteDataBase()
        let authInfo: AuthInfo = auth.authUser(@"userId", db)

        if authInfo.empty:
            resp Http404, $ %* ErrorResponse(
                error: "user.not_found",
                message: "User not found."
            ), CONTENT_TYPE_JSON

        resp Http200, $ %* response.AuthResponse(
            jwt: authInfo.token,
            message: authInfo.info
        ), CONTENT_TYPE_JSON
    
    get "/user":
        let db: Database = newSqliteDataBase()
        let userInfo: UserInfo = checkAuth(request, db)

        if userInfo.empty:
            resp Http401,
                $ %* ErrorResponse(
                    error: "user.unauthorized",
                    message: "Unauthorized request."
                ), CONTENT_TYPE_JSON

        resp Http200, $ %* newUserResponse(userInfo), CONTENT_TYPE_JSON

    error Http404:
        resp Http404, $ %* ErrorResponse(
            error: "not.found",
            message: "Url not found."
        ), CONTENT_TYPE_JSON

runForever()
