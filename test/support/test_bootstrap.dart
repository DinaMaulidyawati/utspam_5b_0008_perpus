import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:utspam_5b_0008_perpus/helpers/database_helper.dart';

/// Inisialisasi SQLite FFI + DB terisolasi per suite test.
Future<void> bootstrapTestDatabase(String suiteId) async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  await DatabaseHelper.useIsolatedTestDatabase(suiteId);
}
