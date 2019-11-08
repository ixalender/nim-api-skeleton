import redis

proc saveData*(token: string, data: string, expireIn: int = 3600): bool =
    let client: Redis = redis.open()
    try:
        discard client.setEx("simpleapi:" & token, expireIn, data)
    except Exception as ex:
        return false
    return true

proc getData*(token: string): RedisString =
    let client: Redis = redis.open()
    client.get("simpleapi:" & token)
