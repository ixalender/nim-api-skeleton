# Package

version       = "0.1.0"
author        = "Александр Некрасов"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
bin           = @["simpleapi"]



# Dependencies

requires "nim >= 1.0.0", "jester >= 0.4.3", "libjwt >= 0.1.0"
