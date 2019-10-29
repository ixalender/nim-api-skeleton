import json
import jester
import httpcore
import user

const CONTENT_TYPE_JSON*: string = "application/json"

type
    Response* = ref object of RootObj
        message*:    string

    AuthResponse* = ref object of Response
        token*: string

    ErrorResponse* = ref object of Response
        error*: string

    UserResponse* = object
        age*: int
        name*: string
        email*: string

proc newUserResponse*(userInfo: UserInfo): UserResponse =
    UserResponse(
        name:   userInfo.name,
        age:    userInfo.age,
        email:  userInfo.email
    )

proc Ok*[T](response: T): string =
    return $ %* response

proc Error*[T](response: T): JsonNode =
    %* response
