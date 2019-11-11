import ../user

type
    Database* = object of RootObj
        findUser*: proc(db: ref Database, userId: string): UserInfo
