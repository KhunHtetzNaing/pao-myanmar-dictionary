import 'package:flutter/material.dart';
import 'package:pao_myanmar_dictionary/data/category.dart';
import 'package:pao_myanmar_dictionary/data/db/sqlite3.dart';
import 'package:pao_myanmar_dictionary/data/word.dart';
import 'package:sqlite3/common.dart';

class Repository {
  CommonDatabase? _wordDatabase, _dictionaryDatabase;
  Future<void> init() async {
    try {
      _wordDatabase = await openSqliteDb("pao_mm_word.sqlite");
      _dictionaryDatabase = await openSqliteDb("pao_mm_dictionary.sqlite");
    } catch (e) {
      debugPrint("$e");
    }
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
