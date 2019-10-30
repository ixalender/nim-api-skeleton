import model

type UserInfo* = ref object of BaseModel
    uid*: string
    name*: string
