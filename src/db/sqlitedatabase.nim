import db_sqlite
import ../user
import database

type
    SqliteDataBase* = ref object of Database

proc openDB(dbFile: string): DbConn =
    open(dbFile, "", "", "")
    
proc closeDB(database: DbConn) =
    database.close()

method findUser*(db: SqliteDataBase, uid: string): UserInfo =
    let database = openDB(db.dbFile)
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

proc newSqliteDataBase*(dbFile: string = "apidatabase.db3"): Database =
    result = SqliteDataBase()
    result.dbFile = dbFile
