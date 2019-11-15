import jester
import libjwt
import httpcore
import strutils
import json
import ../model

const AUTH_HEADER = "authorization"
const AUTH_TYPE = "Bearer"

type JwtToken* = ref object of BaseModel
    value*: string

proc generateJWT*(userId: string, secretKey: string, payload: string): JwtToken =
    var jwt_obj: ptr jwt_t
    discard jwt_new(addr jwt_obj)

    discard jwt_set_alg(
        jwt_obj,
        JWT_ALG_HS256,
        cstring(secretKey), # TODO: use secret key
        cint(secretKey.len)
    )

    if jwt_add_grants_json(jwt_obj, cstring(payload)) > 0:
        return JwtToken(empty: true)

    let token: string = $jwt_encode_str(jwt_obj)
    jwt_free(jwt_obj)

    JwtToken(value: token)

proc getJwt*(headers: HttpHeaders): string =
    if not contains(headers.table, AUTH_HEADER):
        return ""

    let headerValue: string = headers[AUTH_HEADER]
    let findStr = AUTH_TYPE & " "
    let startIdx = headerValue.find(findStr)
    headerValue.substr(findStr.len() + startIdx)

proc parseJwtPayload*(jwtToken: string, secretKey: string): JsonNode =
    var jwt_obj: ptr jwt_t
    if jwt_decode(addr jwt_obj, jwtToken, secretKey, cint(secretKey.len)) > 0:
        new result
        result.kind = JNull
    
    result = parseJson($json_dumps(jwt_obj.grants, 0))