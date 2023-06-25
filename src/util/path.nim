import os, error, std/strutils

let FIREBALL_PATH = getEnv("FIREBALL_PATH")
let BINARY_PATH = getEnv("FIREBALL_BINARY_PATH")

proc getSystemDataPath*(): string =
    if not existsEnv("HOME"):
        raise CommandError.newException("$HOME environment variable not found")

    return getEnv("XDG_DATA_HOME", joinPath("HOME", ".local/share"))

proc getFireballDataPath(): string =
    if FIREBALL_PATH != "":
        return FIREBALL_PATH
    return joinPath(getSystemDataPath(), "fireball")

proc getUserApplicationPath*(): string =
    return joinPath(getSystemDataPath(), "applications")

proc ensureDataPath*(): string =
    var path = getFireballDataPath()

    if not dirExists(path):
        createDir(path)

    return path

proc deepWalk*(path: string) =
    for x in walkDir(path):
        if x.kind == pcDir:
            deepWalk(x.path)
        else:
            echo x.path

proc trimExtensionFromPath*(path: string): string =
    return path.split('/')[^1].split(".tar")[0]
