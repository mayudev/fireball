import os, sugar
import std/strutils, std/options

import parsers/desktop
import parsers/database

import util/archive
import util/error
import util/ask
import util/path


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
    createDir(dest)
    extractInto(path, dest)

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

    var executables: seq[(string, string)] = @[]
    var desktop: Option[DesktopEntry]

    for file in dir:
        if file.endsWith(".desktop"):
            echo "desktop file found at ", file
            var entry = parseDesktopEntry(file)
            desktop = some(entry)
        elif getFilePermissions(file).contains(FilePermission.fpUserExec) and
                 not file.endsWith(".so"):
            echo "found executable ", file
            executables.add((file, extractFilename(file)))

    if desktop.isSome():
        var entry = desktop.get()
        var intendedExecFilename = extractFilename(entry.exec)

        let found = collect:
            for exec in executables:
                if exec[1] == intendedExecFilename: exec

        if found.len() > 0:
            entry.setEntryExecutable(found[0][0])
            var contents = entry.writeOut()

            var desktopPath = joinPath(getUserApplicationPath(), filename & ".desktop")
            writeFile(desktopPath, contents)
            echo "installed desktop entry in ", desktopPath
            echo "running desktop-file-validate on desktop entry, output:"
            echo runValidate(desktopPath)

    let appObject = Application(
        name: filename,
        desktopFile: desktop.isSome(),
        path: dest,
        executables: if desktop.isSome(): @[] else: @[],
    )

    addInstalledApp(appDir, appObject)
