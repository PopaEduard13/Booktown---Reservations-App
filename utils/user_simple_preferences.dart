import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static SharedPreferences _preferences;

  static const _keyFirstName = 'firstname';
  static const _keyLastName = 'lastname';
  static const _keyPhone = 'phone';
  static const _keyEmail = 'email';
  static const _keyFavorites = 'favorites';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setFirstName(String firstName) async =>
      await _preferences.setString(_keyFirstName, firstName);

  static Future setSecondName(String secondName) async =>
      await _preferences.setString(_keyLastName, secondName);

  static Future setPhone(String phone) async =>
      await _preferences.setString(_keyPhone, phone);

  static Future setEmail(String email) async =>
      await _preferences.setString(_keyEmail, email);

  static Future setFavorites(List<String> favorites) async =>
      await _preferences.setStringList(_keyFavorites, favorites);

  static String getFirstName() => _preferences.getString(_keyFirstName);

  static String getSecondName() => _preferences.getString(_keyLastName);

  static String getPhone() => _preferences.getString(_keyPhone);

  static String getEmail() => _preferences.getString(_keyEmail);

  static List<String> getFavorites() =>
      _preferences.getStringList(_keyFavorites);
}
