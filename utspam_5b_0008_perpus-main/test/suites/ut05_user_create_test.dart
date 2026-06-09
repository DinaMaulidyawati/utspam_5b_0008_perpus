import 'package:flutter_test/flutter_test.dart';
import 'package:utspam_5b_0008_perpus/helpers/database_helper.dart';
import '../support/fixtures.dart';
import '../support/test_bootstrap.dart';

/// UT-05: User Registration DB Suite
/// Skenario: penyimpanan pengguna baru ke tabel users.
void main() {
  setUpAll(() async {
    await bootstrapTestDatabase('ut05');
  });

  group('UT-05 UserCreateSuite', () {
    test('UT-05-001 createUser mengembalikan id positif', () async {
      final id = await DatabaseHelper.instance.createUser(
        sampleUser(suffix: 'create1'),
      );
      expect(id, greaterThan(0));
    });

    test('UT-05-002 createUser menyimpan fullName dan username', () async {
      final user = sampleUser(suffix: 'create2');
      await DatabaseHelper.instance.createUser(user);

      final found = await DatabaseHelper.instance.getUserByEmailOrNik(
        user.email,
      );
      expect(found?.fullName, user.fullName);
      expect(found?.username, user.username);
    });

    test('UT-05-003 createUser menyimpan NIK 16 digit', () async {
      final user = sampleUser(suffix: 'create3');
      await DatabaseHelper.instance.createUser(user);

      final found = await DatabaseHelper.instance.getUserByEmailOrNik(
        user.nik,
      );
      expect(found?.nik, user.nik);
      expect(found!.nik.length, 16);
    });
  });
}
