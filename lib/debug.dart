import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Debug class.
class Debug {
  /// Manually set debugging parameters.
  static bool debugMode = true;
  static bool writeLogs = false;
  static String filePath = '';
  static String fileName = 'debug.txt';

  /// Printing log message.
  static void log(Object logMessage){
      if(!debugMode){
        return;
      }

      print('\x1B[33m$logMessage\x1B[0m');

      if(!writeLogs){
        return;
      }

      writeToFile(logMessage);
  }

  /// Writing log message to file. Creates file on device.
  static void writeToFile(Object logMessage) async {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      /// Create file
      File debugLogFile = await File('$appDocPath/$filePath$fileName').create();

      /// Write to file
      debugLogFile.writeAsString(logMessage.toString());
  }
}