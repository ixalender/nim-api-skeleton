#? stdtmpl(subsChar = '$', metaChar = '#')
# 
#proc renderMain*(body: string): string =
#  result = ""
<!DOCTYPE html>
<html>
    <head>
        <title>Simple API Service</title>
        <link rel="stylesheet" type="text/css" href="style.css">
    </head>

    <body>
        <div id="app">
            ${body}
        </div>
    </body>
</html>
#end proc
#
#proc renderIndex*(): string =
#  result = ""
<h1>Simple API</h1>
<h2> with Nim & Jester</h2>
#end proc