import 'dart:io';

import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_platform/universal_platform.dart';

class FileStorage {
  static Future<String> getExternalDocumentPath() async {
    var status = await Permission.storage.status;
    if (!status.isGranted || status.isDenied) {
      await Permission.storage.request();
    } else if (status.isPermanentlyDenied){
      //todo: open app settings
    }
    Directory directory = Directory("");
    if (UniversalPlatform.isAndroid) {
      // download folder in android
      // directory = Directory("/storage/emulated/0/Download");
      directory = await getTemporaryDirectory();
    } else {
      //platform ios
      directory = await getApplicationDocumentsDirectory();
    }

    final exPath = directory.path;
    if (foundation.kDebugMode) {
      print("Saved Path: $exPath");
    }
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<File> writeFile(List<int> bytes, String name) async {
    final path = await _localPath;
    File file = await File('$path/$name.pdf').writeAsBytes(bytes);
    if (foundation.kDebugMode) {
      print("Save file");
    }
    return file;
  }

  static Future<String?> openFile(String url) async {
    final OpenResult result = await OpenFile.open(url);
    switch (result.type) {
      case ResultType.error:
        return result.message;
      case ResultType.fileNotFound:
        return "fileNotFound";
      case ResultType.noAppToOpen:
        return "noAppToOpen";
      case ResultType.permissionDenied:
        return "permissionDenied";
      default:
        return null;
    }}
}