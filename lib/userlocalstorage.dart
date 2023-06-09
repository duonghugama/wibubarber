import 'package:localstorage/localstorage.dart';

class UserLocalStorage {
  static final _storage = LocalStorage('LoginStorage');
  static const _keyName = 'name';
  static const _keyUsername = 'username';
  static const _keyPassword = 'password';
  static const _keyRoles = 'role';

  static Future setRoles(List<String> roles) async => await _storage.setItem(_keyRoles, roles);

  static Future<List<String>> getRoles() async {
    await _storage.ready;
    return await _storage.getItem(_keyRoles) ?? [];
  }

  static Future deleteLogin() async {
    await _storage.deleteItem(_keyUsername);
    await _storage.deleteItem(_keyPassword);
  }

  static Future setUsername(String username) async => await _storage.setItem(_keyUsername, username);

  static Future<String> getUsername() async {
    await _storage.ready;
    return await _storage.getItem(_keyUsername) ?? "";
  }

  static Future setname(String name) async => await _storage.setItem(_keyName, name);

  static Future<String> getname() async {
    await _storage.ready;
    return await _storage.getItem(_keyName) ?? "";
  }

  static Future setPassword(String password) async => await _storage.setItem(_keyPassword, password);

  static Future<String> getPassword() async {
    await _storage.ready;
    return await _storage.getItem(_keyPassword) ?? "";
  }
}
