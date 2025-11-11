import 'dart:io';
import 'package:expenso/core/constants/default_categories.dart';
import 'package:expenso/data/backup/encryption_service.dart';
import 'package:expenso/data/db/db_helper.dart';
import 'package:expenso/services/log_service.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart';

class DBSyncService {
  static final DBHelper _dbHelper = DBHelper();

  static Future<String?> exportDatabase() async {
    try {
      final db = await _dbHelper.database;
      final dbPath = db.path;

      final rawBytes = await File(dbPath).readAsBytes();

      // 🔐 App encryption
      final encrypted = await EncryptionService.encryptBytes(rawBytes);

      // Let user pick save directory
      final dirPath = await getDirectoryPath();
      if (dirPath == null) return null;

      final file = File(join(dirPath, 'expenso_backup.silverFoxDb'));
      await file.writeAsBytes(encrypted, flush: true);

      LogService.log("Sucess", 'Database exported to: ${file.path}');
      return file.path;
    } catch (e, st) {
      LogService.log("Error", 'Error exporting database: $e\n$st');
      return null;
    }
  }

  /// ✅ Import & decrypt `.silverFoxDb` into local DB
  static Future<bool> importDatabase() async {
    try {
      // Let user pick file
      final XFile? file = await openFile(
        acceptedTypeGroups: [
          XTypeGroup(
            label: 'Silver Fox DB',
            extensions: ['silverFoxDb'],
          ),
        ],
      );

      if (file == null) return false;
      final encryptedBytes = await File(file.path).readAsBytes();

      // 🔓 Decrypt using app encryption
      final decryptedBytes = await EncryptionService.decryptBytes(encryptedBytes);

      // Replace existing DB
      final db = await _dbHelper.database;
      final dbPath = db.path;

      final dbFile = File(dbPath);
      await dbFile.writeAsBytes(decryptedBytes, flush: true);

      LogService.log("Sucess", 'Database imported successfully.');
      return true;
    } catch (e, st) {
      LogService.log("Error", 'Error importing database: $e\n$st');
      return false;
    }
  }

  /// ✅ Clears all tables in the DB
  static Future<void> clearDatabase() async {
    try {
      final db = await _dbHelper.database;

      await db.delete('expenses');
      await db.delete('categories');
      await db.delete('budgets');

      // Re-insert default categories
      for (var category in categories) {
        await db.insert('categories', {
          'id': category.id,
          'name': category.name,
          'iconCodePoint': category.icon.codePoint,
          'fontFamily': category.icon.fontFamily,
          'state': category.state,
        });
      }

      LogService.log("Sucess", 'Database cleared successfully.');
    } catch (e, st) {
      LogService.log("Error", 'Error clearing database: $e\n$st');
    }
  }
}
