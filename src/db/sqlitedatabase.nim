import strutils
import db_sqlite
import ../user
import database
import logging

type
    SqliteDataBase* = ref object of Database

    DatabaseException* = object of Exception

proc openDB(dbFile: string): DbConn =
    open(dbFile, "", "", "")
    
proc closeDB(database: DbConn) =
    database.close()

method findUser*(db: SqliteDataBase, uid: string): UserInfo =
    let database = openDB(db.dbFile)
    let row = try:
        database.getRow(
            sql"SELECT uid, name FROM User WHERE uid = ?;", uid
        )
    except Exception as ex:
        logging.error("Could get user data: $1" % ex.msg)
        raise DatabaseException.newException("Can not get data from database.")

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
