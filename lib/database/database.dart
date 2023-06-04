import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../providers/database_providers.dart';

const String dbFilename = '/db.json';
const String appSettingsFilename = '/appsettings.json';

//Fetch some database

//Get local path (AppData/)
Future<String> get _localPath async {
  final dir = await getApplicationDocumentsDirectory();
  return dir.path;
}

//Get file location
Future<File> _filePath({required String filename}) async {
  final path = await _localPath;
  File dbFile = File('$path$filename');
  if (!dbFile.existsSync()) {
    dbFile = await File('$path$filename').create(recursive: true);
    return dbFile;
  }
  return dbFile;
}

//BUDGET DATABASE
//Get budget Database
fetchDbJson() async {
  final dbFile = await _filePath(filename: dbFilename);
  final db = await jsonDecode(await dbFile.readAsString());
  return db;
}

//Save budget Database
saveDbJson({required List<BudgetHistoryData> data}) async {
  final dbFile = await _filePath(filename: dbFilename);
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
