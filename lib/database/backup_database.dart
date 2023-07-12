// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:io';
import 'package:fl_budget_tracker/database/database.dart';
import 'package:fl_budget_tracker/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

//Export database to external storage

//get backup db file
Future<File?> getBackupDbFile({bool create = true}) async {
  Directory? directory = await getExternalStorageDirectory();
  String newPath = "";
  List<String> paths = directory!.path.split("/");
  for (int x = 1; x < paths.length; x++) {
    String folder = paths[x];
    if (folder != "Android") {
      newPath += "/" + folder;
    } else {
      break;
    }
  }
  newPath = newPath + "/budget_tracker";
  directory = await Directory(newPath).create(recursive: true);

  if (create) {
    if (await permissionIsGranted()) {
      File file = await File(directory.path + '/db_backup.json').create(recursive: true);
      return file;
    }
  } else {
    File file = File(directory.path + '/db_backup.json');
    if (file.existsSync()) {
      return file;
    } else {
      return null;
    }
  }
  return null;
}

//export db
void exportBackupDb() async {
  if (await permissionIsGranted()) {
    File? file = await getBackupDbFile();
    //get current database
    final db = await fetchDb();
    //encode database and write it in backup file
    final dbEncode = jsonEncode(db);
    file!.writeAsStringSync(dbEncode);
  }
}

//import db and return data
getBackupDb() async {
  try {
    final backupDbFile = await getBackupDbFile(create: false);
    final db = await jsonDecode(await backupDbFile!.readAsString());
    return db;
  } catch (e) {
    //
  }
}
