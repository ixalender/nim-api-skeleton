import redis

proc saveData*(token: string, data: string): bool =
    let client: Redis = redis.open()
    try:
        client.setk("simpleapi:" & token, data)
    except Exception as ex:
        return false
    return true

proc getData*(token: string): RedisString =
    let client: Redis = redis.open()
    client.get("simpleapi:" & token)
