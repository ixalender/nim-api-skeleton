import ../user

type
    Database* = ref object of RootObj
        dbFile*: string

method findUser*(db: Database, userId: string): UserInfo {.base.} =
    discard
