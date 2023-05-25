import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../providers/database_providers.dart';

Future<String> get _localPath async {
  final dir = await getApplicationDocumentsDirectory();
  return dir.path;
}

Future<File> get _dbFile async {
  final path = await _localPath;
  File dbFile = File('$path/db.json');
  if (!dbFile.existsSync()) {
    dbFile = await File('$path/db.json').create(recursive: true);
  }
  return dbFile;
}

fetchDbJson() async {
  final dbFile = await _dbFile;
  final db = await jsonDecode(await dbFile.readAsString());
  return db;
}

saveDbJson({required List<BudgetHistoryData> data}) async {
  final dbFile = await _dbFile;
  Map convertedData = {};

  for (BudgetHistoryData budget in data) {
    convertedData[budget.token] = [
      budget.amount,
      budget.type,
      budget.detail,
      budget.date.toIso8601String()
    ];
  }

  final jsonEncodedConvertedData = jsonEncode(convertedData);
  return await dbFile.writeAsString(jsonEncodedConvertedData);
}
