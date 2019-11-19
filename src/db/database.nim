import ../user

type
    Database* = ref object of RootObj
        dbFile*: string

method findUser*(db: Database, userId: string): UserInfo {.base.} =
    discard

var dbInst {.threadvar.}: Database

proc instance*(): Database = dbInst

proc init*(database: Database) =
    dbInst = database
