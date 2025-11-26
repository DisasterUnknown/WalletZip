import 'package:permission_handler/permission_handler.dart';

// This function should be called from your UI before attempting to export.
Future<bool> requestManageExternalStoragePermission() async {
  // Check the current status of the special permission
  var status = await Permission.manageExternalStorage.status;

  if (status.isGranted) {
    // Permission is already granted.
    return true;
  } else {
    // Permission is not granted, request it.
    // NOTE: This will open the specific Android Settings screen,
    // NOT the standard pop-up dialog.
    var result = await Permission.manageExternalStorage.request();

    // Check the status *after* the user returns from settings
    if (result.isGranted) {
      return true;
    } else {
      // The user denied or dismissed the settings screen.
      return false;
    }
  }
}
