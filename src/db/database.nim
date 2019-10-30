type
    DataBaseProvider* = ref object of RootObj

    DataBaseContainer*[T] = ref object of RootObj
        empty*: bool
        db*: T

proc newDataBase*[T](): DataBaseContainer[T] =
    new(result)
    result.db = new(T)
    