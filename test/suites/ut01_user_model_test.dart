import 'package:flutter_test/flutter_test.dart';
import 'package:utspam_5b_0008_perpus/models/user.dart';
import '../support/fixtures.dart';

/// UT-01: User Model Suite
/// Skenario: serialisasi dan deserialisasi data pengguna.
void main() {
  group('UT-01 UserModelSuite', () {
    test('UT-01-001 toMap menyimpan semua field wajib', () {
      final user = sampleUser(id: 1, suffix: '01');
      final map = user.toMap();

      expect(map['fullName'], user.fullName);
      expect(map['nik'], user.nik);
      expect(map['email'], user.email);
      expect(map['username'], user.username);
      expect(map['password'], user.password);
    });

    test('UT-01-002 fromMap membangun User dari Map database', () {
      final user = User.fromMap({
        'id': 10,
        'fullName': 'Andi',
        'nik': '3201010101010001',
        'email': 'andi@gmail.com',
        'address': 'Solo',
        'phone': '081111111111',
        'username': 'andi',
        'password': 'pass123',
      });

      expect(user.id, 10);
      expect(user.fullName, 'Andi');
      expect(user.email, 'andi@gmail.com');
    });

    test('UT-01-003 round-trip toMap dan fromMap konsisten', () {
      final original = sampleUser(id: 5, suffix: 'rt');
      final restored = User.fromMap(original.toMap());

      expect(restored.fullName, original.fullName);
      expect(restored.nik, original.nik);
      expect(restored.email, original.email);
    });
  });
}
