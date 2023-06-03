import std/parsecfg

type DesktopEntry* = ref object
    name*: string
    exec*: string
    icon*: string

const root = "Desktop Entry"

proc parseDesktopEntry*(path: string): DesktopEntry =
    let dict = loadConfig(path)
    var entry = DesktopEntry()
    entry.name = dict.getSectionValue(root, "Name")
    entry.exec = dict.getSectionValue(root, "Exec")
    entry.icon = dict.getSectionValue(root, "Icon")

    return entry
