from std/os import commandLineParams
from std/strformat import fmt
import argparse
import install, uninstall

from util/error import CommandError

var parser = newParser:
    help("A package manager for tarballs")
    command("install"):
        arg("path")
        help("Installs package")
        run:
            install(opts.path)
    command("uninstall"):
        arg("name")
        help("Uninstalls package")
        run:
            uninstall(opts.name)


when isMainModule:
    try:
        parser.run(commandLineParams())
        # if params.argparse_install_opts.isSome():
        #     var install_params = params.argparse_install_opts.get()
        #     install(install_params.path)
    # Command errors
    except CommandError as err:
        stderr.write fmt"error: {err.msg}{'\n'}"
    # Handle help
    except ShortCircuit as err:
        if err.flag == "argparse_help":
            echo err.help
    except UsageError:
        echo parser.help()
