import jester
import asyncdispatch
import strtabs
import strutils
import json

import auth
import user
import response

import db.database
import db.sqlitedatabase

routes:
    post "/auth/@userId":
        let authInfo: AuthInfo = authUser @"userId"

        if authInfo.empty:
            resp Http403, $ %* ErrorResponse(
                error: "user.forbidden",
                message: "Permission denied."
            ), CONTENT_TYPE_JSON

        resp Http200, $ %* response.AuthResponse(
            token: authInfo.token,
            message: authInfo.info
        ), CONTENT_TYPE_JSON
    
    get "/users/@userId":
        withAccess(@"userId", request):
            let dbcont: DataBaseContainer[SqliteDataBase] = newDataBase[SqliteDataBase]()
            let userInfo: UserInfo = dbcont.db.findUser @"userId"

            if userInfo.empty:
                halt Http404, $ %* ErrorResponse(
                    error: "user.not_found",
                    message: "User not found."
                )

            resp Http200, $ %* newUserResponse(userInfo), CONTENT_TYPE_JSON

runForever()
