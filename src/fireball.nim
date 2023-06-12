from std/os import commandLineParams
from std/strformat import fmt
import argparse

from install import install
from util/error import CommandError

var parser = newParser:
    help("A package manager for tarballs")
    # Install
    command("install"):
        arg("path")
        run:
            echo "install"

when isMainModule:
    try:
        var params = parser.parse(commandLineParams())
        if params.argparse_install_opts.isSome():
            var install_params = params.argparse_install_opts.get()
            install(install_params.path)
    # Command errors
    except CommandError as err:
        stderr.write fmt"error: {err.msg}{'\n'}"
    # Handle help
    except ShortCircuit as err:
        if err.flag == "argparse_help":
            echo err.help
    except UsageError:
        echo parser.help()
