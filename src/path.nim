import os, error, std/strutils

proc getSystemDataPath*(): string =
    if not existsEnv("HOME"):
        raise CommandError.newException("$HOME environment variable not found")

    return joinPath(getEnv("HOME"), getEnv("XDG_DATA_HOME",
            ".local/share"))

proc getFireballDataPath(): string =
    joinPath(getSystemDataPath(), "fireball")

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
