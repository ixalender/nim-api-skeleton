import strutils

proc jester_fix_error_msg*(msg: string): string =
    let i = msg.find("\nAsync traceback") - 1
    return msg.substr(0, i)
