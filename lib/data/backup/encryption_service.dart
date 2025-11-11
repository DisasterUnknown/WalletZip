import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  static final _key = encrypt.Key.fromUtf8('0123456789ABCDEF0123456789ABCDEF');
  static final _iv = encrypt.IV.fromUtf8('ABCDEF0123456789');

  static Future<Uint8List> encryptBytes(List<int> bytes) async {
    final encrypter = encrypt.Encrypter(
      encrypt.AES(_key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
    );
    final encrypted = encrypter.encryptBytes(bytes, iv: _iv);
    return Uint8List.fromList(encrypted.bytes);
  }

  static Future<Uint8List> decryptBytes(List<int> bytes) async {
    final encrypter = encrypt.Encrypter(
      encrypt.AES(_key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
    );
    final decrypted = encrypter.decryptBytes(
      encrypt.Encrypted(Uint8List.fromList(bytes)),
      iv: _iv,
    );
    return Uint8List.fromList(decrypted);
  }
}
