import os, sugar
import zippy/tarballs
import std/strutils
import parsers/cfg

import error
import path

proc install*(path: string) =
    # validate file path
    let valid = fileExists(path)
    if not valid:
        raise CommandError.newException("file not found")
    let appDir = ensureDataPath()

    # construct destination path
    let filename = trimExtensionFromPath(path)
    let dest = joinPath(appDir, filename)

    echo "extracting into ", dest
    extractAll(path, dest)

    # check for the true tarball root
    # (some tarballs are packaged like: archive.tar/Archive/*contents* and others
    # like archive.tar/*contents*)
    let roots = collect:
        for k, p in walkDir(dest): (kind: k, path: p)

    var root = dest
    # if all that root contains is a single directory then its the true root
    if roots.len == 1 and roots[0].kind == pcDir:
        root = roots[0].path

    # traverse files in root
    let dir = collect:
        for k, p in walkDir(root):
            if k == pcFile: p

    for file in dir:
        if file.endsWith(".desktop"):
            echo "desktop file found at ", file
            var entry = parseDesktopEntry(file)
        elif getFilePermissions(file).contains(FilePermission.fpUserExec):
            echo "found executable ", file
