import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pao_myanmar_dictionary/data/category.dart';
import 'package:pao_myanmar_dictionary/data/word.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

class Repository {
  Database? _wordDatabase, _dictionaryDatabase;
  Future<void> init() async {
    try {
      _wordDatabase = sqlite3.open(await _copyDatabase("pao_mm_word.sqlite"),
          mode: OpenMode.readOnly);

      _dictionaryDatabase = sqlite3.open(
          await _copyDatabase("pao_mm_dictionary.sqlite"),
          mode: OpenMode.readOnly);
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future<String> _copyDatabase(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final data = await rootBundle.load("assets/db/$fileName");
    final path = join(directory.path, fileName);
    await File(path).writeAsBytes(data.buffer.asInt8List());
    return path;
  }

  List<CategoryItem> fetchCategories() {
    final result = _wordDatabase?.select("SELECT * FROM categories");
    return result?.map((row) {
          final id = row['category_id'];
          final mm = row['category_mm'];
          final pao = row['category_pao'];
          return CategoryItem(id: id, mm: mm, pao: pao);
        }).toList() ??
        [];
  }

  List<WordItem> fetchWordsByCategory(CategoryItem item) {
    final result = _wordDatabase?.select(
        "SELECT * FROM dictionary_items WHERE category_id = ?", [item.id]);
    return _parseWords(result);
  }

  List<WordItem> fetchWords() {
    final result =
        _dictionaryDatabase?.select("SELECT * FROM pao_mm_dictionary");
    return _parseWords(result);
  }

  List<WordItem> _parseWords(ResultSet? resultSet) {
    return resultSet?.map((row) {
          final id = row['item_id'];
          final pao = row['word_pao'];
          final mm = row['word_mm'];
          return WordItem(id: int.parse(id.toString()), mm: mm, pao: pao);
        }).toList() ??
        [];
  }
}
