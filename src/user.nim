type BaseObject* = ref object of RootObj
    empty*: bool

type UserInfo* = ref object of BaseObject
    uid*: string
    name*: string

proc getUser*(userId: string): UserInfo =
    # TODO: read user from database
    if userId == "unique-id":
        UserInfo(
            uid: "unique-id",
            name: "Alex"
        )
    else:
        UserInfo(empty: true)