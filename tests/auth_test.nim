import jester
import httpcore
import auth/auth
import db/sqlitedatabase
import unittest

suite "auth test":
    test "authenticate non-existing user":
        let authInfo: AuthInfo = auth.authUser("userId", newSqliteDataBase())
        check authInfo.empty == true

    test "check access of non-existing user":
        let headers: HttpHeaders = httpcore.HttpHeaders(
            table: TableRef["", @[""]]()
        )
        let checkResult = auth.checkAuth("userId", headers)
        check checkResult == false

