import redis
import strutils

const keyPrefix = "simpleapijwt:"

proc saveJwtData*(token: string, data: string, expireIn: int = 3600): bool =
    let client: Redis = redis.open()
    try:
        discard client.setEx(keyPrefix & token, expireIn, data)
    except Exception as ex:
        return false
    return true

proc getJwtData*(token: string): RedisString =
    let client: Redis = redis.open()
    let data = client.get(keyPrefix & token)
    result = if data == redisNil: ""
                            else: data.strip()