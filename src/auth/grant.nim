import times

type Grant* = ref object of RootObj
    iss*:   string
    exp*:   string
    # admin*: bool

proc newGrant*(userId: string): Grant =
    let exp: Time = times.getTime() + initDuration(seconds = 3600)
    Grant(
        iss: userId,
        exp: $exp.toUnix
    )
