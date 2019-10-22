import json
import jester
import httpcore

const CONTENT_TYPE_JSON*: string = "application/json"

type Response* = ref object of RootObj
    message*:    string

type AuthResponse* = ref object of Response
    token*: string

type ErrorResponse* = ref object of Response
    error*: string

type UserResponse* = object
    age*: int
    name*: string
    email*: string


proc Ok*[T](response: T): string =
    return $ %* response

proc Error*[T](response: T): JsonNode =
    %* response
    