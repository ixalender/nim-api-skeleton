import options
import httpcore
import tables

type ApiRequest* = ref object of RootObj
    headers: Option[HttpHeaders]

proc newHttpHeaders(): HttpHeaders =
    new result
    result.table = newTable[string, seq[string]]()

proc headers*(self: ApiRequest): HttpHeaders =
    if self.headers.isNone:
        newHttpHeaders()
    else:
        self.headers.get()

proc newApiRequest*(headers: HttpHeaders): ApiRequest =
    ApiRequest(headers: some(headers))