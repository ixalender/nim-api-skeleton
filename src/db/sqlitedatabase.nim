import database
import db_sqlite
import ../user

type
    SqliteDataBase* = ref object of DataBaseProvider
        db*: DbConn

proc openDB(): SqliteDataBase =
    new result
    result.db = open("apidatabase.db3", "", "", "")
    
proc closeDB(database: SqliteDataBase) =
    database.db.close()

proc findUser*(sqlite: SqliteDataBase, uid: string): UserInfo =
    let database = openDB()
    let row = database.db.getRow(
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
    