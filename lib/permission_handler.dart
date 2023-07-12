import 'package:permission_handler/permission_handler.dart';

// request required permission
Future<bool> permissionIsGranted() async {
  Permission storagePermission = Permission.storage;
  if (await storagePermission.isGranted) {
    return true;
  } else {
    return storagePermission.request().isGranted;
  }
}
