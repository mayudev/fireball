import os
import parsers/database
import util/path
import util/error

proc uninstall*(name: string) =
    let appDir = ensureDataPath()
    let db = getApps(appDir)

    let i = db.find(name)
    if (i < 0):
        raise CommandError.newException("Package not found")

    let details = db[i]

    # Remove app directory
    let path = dirExists(details.path)

    if path:
        echo "deleting directory ", details.path
        removeDir(details.path)
    else:
        echo "directory does not exist, skipping"

    # Unlink executables if applicable
    # TODO

    # Remove desktop entry
    if details.desktopFile:
        let desktopPath = getUserApplicationPath()
        let desktopFilePath = joinPath(desktopPath, details.name & ".desktop")
        echo "deleting desktop entry"
        if fileExists(desktopFilePath):
            removeFile(desktopFilePath)

    # Remove from database
    uninstallApp(appDir, i)
