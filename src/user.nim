type BaseObject* = ref object of RootObj
    empty*: bool

type UserInfo* = ref object of BaseObject
    age*: int
    name*: string
    email*: string

proc getUser*(userId: string): UserInfo =
    # TODO: read user from database
    if userId == "Alex":
        UserInfo(
            name: "Alex",
            age: 35,
            email: "anekrasov@fastmail.com"
        )
    else:
        UserInfo(empty: true)