import 'package:flutter_test/flutter_test.dart';
import 'package:utspam_5b_0008_perpus/helpers/database_helper.dart';
import '../support/fixtures.dart';
import '../support/test_bootstrap.dart';

/// UT-06: User Query Suite
/// Skenario: pencarian dan validasi keunikan email/username.
void main() {
  late int userId;

  setUpAll(() async {
    await bootstrapTestDatabase('ut06');
    userId = await DatabaseHelper.instance.createUser(
      sampleUser(suffix: 'query'),
    );
  });

  group('UT-06 UserQuerySuite', () {
    test('UT-06-001 getUserByEmailOrNik via email', () async {
      final user = await DatabaseHelper.instance.getUserByEmailOrNik(
        'user_query@gmail.com',
      );
      expect(user, isNotNull);
      expect(user!.id, userId);
    });

    test('UT-06-002 getUserByEmailOrNik via NIK', () async {
      final expectedNik = sampleUser(suffix: 'query').nik;
      final user = await DatabaseHelper.instance.getUserByEmailOrNik(
        expectedNik,
      );
      expect(user?.nik, expectedNik);
    });

    test('UT-06-003 isEmailExists true untuk email terdaftar', () async {
      final exists = await DatabaseHelper.instance.isEmailExists(
        'user_query@gmail.com',
      );
      expect(exists, true);
    });

    test('UT-06-004 isUsernameExists true untuk username terdaftar', () async {
      final exists = await DatabaseHelper.instance.isUsernameExists(
        'user_query',
      );
      expect(exists, true);
    });

    test('UT-06-005 isEmailExists false untuk email tidak ada', () async {
      final exists = await DatabaseHelper.instance.isEmailExists(
        'tidakada@gmail.com',
      );
      expect(exists, false);
    });
  });
}
