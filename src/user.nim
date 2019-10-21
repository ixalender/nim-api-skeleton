
type UserInfo* = ref object of RootObj
    age*: int
    name*: string
    email*: string

proc getUser*(userId: string): UserInfo =
    if userId == "Alex":
        UserInfo(
            name: "Alex",
            age: 35,
            email: "anekrasov@fastmail.com"
        )
    else: nil