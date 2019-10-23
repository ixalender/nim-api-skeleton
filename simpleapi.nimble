# Package

version       = "0.1.0"
author        = "Александр Некрасов"
description   = "Experimental API app with Nim"
license       = "MIT"
srcDir        = "src"
bin           = @["simpleapi"]



# Dependencies

when defined(nimdistros):
    import distros
    if detectOs(MacOSX):
        foreignDep "libjwt"

requires "nim >= 1.0.0", "jester >= 0.4.3", "libjwt >= 0.1.0"

