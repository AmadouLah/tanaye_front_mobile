import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static Future<void> setValue(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String> getValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('utilisateurId');
    await prefs.remove('nom');
    await prefs.remove('prenom');
    await prefs.remove('email');
    await prefs.remove('telephone');
    await prefs.remove('role');
    await prefs.remove('estVerifie');
  }
}
