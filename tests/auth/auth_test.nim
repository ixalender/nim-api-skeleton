import jester
import httpcore
import auth/auth
import db/sqlitedatabase

when isMainModule:
    let authInfo: AuthInfo = auth.authUser("userId", newSqliteDataBase())
    doAssert(authInfo.empty == true)
    
    let headers: HttpHeaders = httpcore.HttpHeaders(
        table: TableRef["", @[""]]()
    )
    let checkResult = auth.checkAuth("userId", headers)
    doAssert(checkResult == false)
    
