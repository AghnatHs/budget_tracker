import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> get _appSettingPath async {
  final dir = await getApplicationDocumentsDirectory();
  return dir.path;
}

Future<File> get _appSettingFile async {
  final path = await _appSettingPath;
  File file = File('$path/appSetting.json');
  if (!file.existsSync()) {
    file = await File('$path/appSetting.json').create(recursive: true);
  }
  return file;
}

fetchAppSettingJson() async {
  final appSettingFile = await _appSettingFile;
  final appSettings = await jsonDecode(await appSettingFile.readAsString());
  return appSettings;
}

saveAppSettingJson(){}