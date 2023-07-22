import json, os

const filename = "fireball.json"

type Application* = object
  name*: string
  desktopFile*: bool
  path*: string
  executables*: seq[string]

type FireballDatabase = seq[Application]

proc openDatabase(path: string): FireballDatabase =
  let path = joinPath(path, filename)
  if not fileExists(path):
    writeFile(path, "[]")

  let db = readFile(path)

  let jsonObject = parseJson(db)
  let element = to(jsonObject, FireballDatabase)
  return element

proc `==`*(app: Application, name: string): bool =
  return app.name == name

proc closeDatabase(db: FireballDatabase, path: string) =
  let path = joinPath(path, filename)
  let serialized = %* db
  writeFile(path, $serialized)

proc getApps*(path: string): FireballDatabase =
  return openDatabase(path)

proc addInstalledApp*(path: string, app: Application) =
  var db = openDatabase(path)
  db.add(app)
  db.closeDatabase(path)

proc uninstallApp*(path: string, index: int) =
  var db = openDatabase(path)
  del(db, index)
  db.closeDatabase(path)
