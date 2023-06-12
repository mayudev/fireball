import osproc
import error

proc extractInto*(path: string, dest: string) =
    let tar = startProcess("/bin/tar", "", ["-xvf", path, "-C", dest])
    let code = tar.waitForExit()

    if code != 0:
        raise CommandError.newException("tar failed")
