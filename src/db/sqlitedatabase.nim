import db_sqlite
import ../user

type
    SqliteDataBase* = ref object of RootObj

proc openDB(): DbConn =
    open("apidatabase.db3", "", "", "")
    
proc closeDB(database: DbConn) =
    database.close()

proc newDataBase*(): SqliteDataBase =
        new(result)

proc findUser*(sqlite: SqliteDataBase, uid: string): UserInfo =
    let database = openDB()
    let row = database.getRow(
        sql"SELECT uid, name FROM User WHERE uid = ?;", uid
    )
    database.closeDB()

    if row[0].len != 0:
        UserInfo(
            uid: row[0],
            name: row[1]
        )
    else:
        UserInfo(empty: true)
    