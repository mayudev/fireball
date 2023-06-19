import json, os

const filename = "fireball.json"

type Application* = object
  name*: string
  desktopFile*: string
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

proc closeDatabase(db: FireballDatabase, path: string) =
  let path = joinPath(path, filename)
  let serialized = %* db
  writeFile(path, $serialized)

proc addInstalledApp*(path: string, app: Application) =
  var db = openDatabase(path)
  db.add(app)
  db.closeDatabase(path)
