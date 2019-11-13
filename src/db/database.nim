import ../user

type
    Database* = ref object of RootObj
        dbFile*: string

proc findUser*(db: var Database, userId: string): UserInfo =
    UserInfo(empty: true)
