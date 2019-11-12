import jester
import httpcore
import auth/auth
import db/sqlitedatabase

when isMainModule:
    let authInfo: AuthInfo = auth.authUser("userId", newDataBase())
    doAssert(authInfo.empty == true)
    
    let headers: HttpHeaders = new httpcore.HttpHeaders
    headers.table = new TableRef["", @[""]]
    let checkResult = auth.checkAuth("userId", headers)
    doAssert(checkResult == false)
    
