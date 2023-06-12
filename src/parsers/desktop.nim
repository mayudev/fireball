import std/parsecfg, std/streams, osproc

type DesktopEntry* = ref object
    name*: string
    exec*: string
    icon*: string
    raw: Config

const root = "Desktop Entry"

proc parseDesktopEntry*(path: string): DesktopEntry =
    let dict = loadConfig(path)
    var entry = DesktopEntry()
    entry.name = dict.getSectionValue(root, "Name")
    entry.exec = dict.getSectionValue(root, "Exec")
    entry.icon = dict.getSectionValue(root, "Icon")
    entry.raw = dict

    return entry

proc setEntryExecutable*(entry: DesktopEntry, exec: string) =
    entry.raw.setSectionKey(root, "Exec", exec)

# need to cleanup to fix some issues with nim's ini parser
proc cleanup(contents: StringStream): string =
    var fin = ""
    var line = ""
    while contents.readLine(line):
        if line.contains('=') or line.contains('['):
            fin &= line & '\n'
    return fin


proc writeOut*(entry: DesktopEntry): string =
    var stream = newStringStream()
    entry.raw.writeConfig(stream)
    stream.setPosition(0)

    return cleanup(stream)

proc runValidate*(path: string): string =
    let validator = startProcess("/bin/desktop-file-validate", "", [
            "--no-hints", path])
    discard validator.waitForExit()
    return validator.outputStream.readAll()
