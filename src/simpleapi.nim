import os
import jester
import asyncdispatch
import strtabs
import strutils
import json

import utils
import auth/auth
import user
import response
import request
import exceptions

import db/database
import db/sqlitedatabase
import views/index

auth.jwtSecret getEnv("JWT_SECRET")
database.init newSqliteDataBase()

routes:
    get "/":
        resp renderMain(renderIndex())

    post "/auth/@userId":
        let authInfo: AuthInfo = auth.authUser @"userId"

        if authInfo.empty:
            raise newException(NotFoundException, "user.not_found")

        resp Http200, $ %* response.AuthResponse(
            jwt: authInfo.token,
            message: authInfo.info
        ), CONTENT_TYPE_JSON
    
    get "/user":
        let req = newApiRequest(request.headers)
        let userInfo: UserInfo = checkAuth req

        if userInfo.empty:
            resp Http401,
                $ %* ErrorResponse(
                    error: "user.unauthorized",
                    message: "Unauthorized request."
                ), CONTENT_TYPE_JSON

        resp Http200, $ %* newUserResponse userInfo, CONTENT_TYPE_JSON

    error Http404:
        resp Http404, $ %* ErrorResponse(
            error: "not.found",
            message: "Url not found."
        ), CONTENT_TYPE_JSON
    
    error NotFoundException:
        resp Http404, $ %* ErrorResponse(
            error: utils.jester_fix_error_msg(exception.msg),
            message: "Data's not found."
        ), CONTENT_TYPE_JSON

    error Exception:
        resp Http500, $ %* ErrorResponse(
            error: "internal.error",
            message: "Internal service error."
        ), CONTENT_TYPE_JSON

runForever()
