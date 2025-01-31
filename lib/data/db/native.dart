import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:sqlite3/common.dart' show CommonDatabase;
import 'package:sqlite3/sqlite3.dart' show sqlite3;

Future<CommonDatabase> openSqliteDb(String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  final data = await rootBundle.load("assets/db/$fileName");
  final path = join(directory.path, fileName);
  await File(path).writeAsBytes(data.buffer.asInt8List());
  return sqlite3.open(path);
}
