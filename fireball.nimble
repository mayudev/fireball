# Package

version       = "0.1.0"
author        = "mayudev"
description   = "A package manager for tarballs"
license       = "LGPL-3.0-or-later"
srcDir        = "src"
bin           = @["fireball"]


# Dependencies

requires "nim >= 1.6.12"
requires "argparse >= 4.0.0"