import
    jester,
    httpcore,
    auth/auth,
    db/sqlitedatabase,
    db/database,
    user,
    unittest,
    request

type RequestMock = ref object of RootObj

database.init newSqliteDataBase()

method headers*(req: RequestMock): HttpHeaders {.base.} =
    result = httpcore.HttpHeaders(
        table: TableRef["", @[""]]()
    )

suite "auth test":
    test "authenticate non-existing user":
        let authInfo: AuthInfo = auth.authUser "userId"
        check authInfo.empty == true

    test "check access of non-existing user":
        let headers = httpcore.HttpHeaders(
            table: TableRef["", @[""]]()
        )
        let db: Database = newSqliteDataBase()
        let checkResult: UserInfo = auth.checkAuth request.newApiRequest(headers)
        check checkResult.empty

