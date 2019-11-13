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

task test, "Runs the test suite":
  exec "nim c -r tests/auth_test"

requires "nim >= 1.0.0"
requires "jester >= 0.4.3"
requires "libjwt >= 0.1.0"
requires "redis >= 0.2.0"
