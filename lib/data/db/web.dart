import 'package:flutter/services.dart';
import 'package:sqlite3/common.dart' show CommonDatabase;

import 'package:sqlite3/wasm.dart'
    show IndexedDbFileSystem, SqlFlag, Sqlite3Filename, WasmSqlite3;

Future<CommonDatabase> openSqliteDb(String fileName) async {
  const name = 'pao_myanmar_dictionary';
  final sqlite = await WasmSqlite3.loadFromUrl(Uri.parse('sqlite3.wasm'));
  final fileSystem = await IndexedDbFileSystem.open(dbName: name);

  final data = await rootBundle.load("assets/db/$fileName");
  final result = fileSystem.xOpen(
      Sqlite3Filename("/$fileName"), SqlFlag.SQLITE_OPEN_CREATE);
  result.file.xWrite(data.buffer.asUint8List(), 0);
  await fileSystem.flush();
  sqlite.registerVirtualFileSystem(fileSystem, makeDefault: true);
  return sqlite.open(fileName);
}
