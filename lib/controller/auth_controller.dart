import 'package:tanaye_front_mobile/utils/shared_preference_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var token = ''.obs;
  static const String _baseUrl = 'http://10.0.2.2:9999/api/auth';

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future<void> loadToken() async {
    final stored = await SharedPreferenceService.getValue('token');
    token.value = stored;
  }

  Future<void> initialize() async {
    final storedToken = await SharedPreferenceService.getValue('token');
    token.value = storedToken;
  }

  Future<String?> login(String identifiant, String motDePasse) async {
    isLoading.value = true;
    try {
      final resp = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identifiant': identifiant,
          'motDePasse': motDePasse,
        }),
      );
      if (resp.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(resp.body);
        await _saveAuth(data);
        return null;
      }
      return _extractError(resp.body);
    } catch (e) {
      return e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await SharedPreferenceService.clearUserData();
    token.value = '';
  }

  Future<String?> register({
    required String nom,
    required String prenom,
    required String email,
    required String telephone,
    required String motDePasse,
    required String confirmationMotDePasse,
    required String role,
  }) async {
    isLoading.value = true;
    try {
      final resp = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'telephone': telephone,
          'motDePasse': motDePasse,
          'confirmationMotDePasse': confirmationMotDePasse,
          'role': role,
        }),
      );
      if (resp.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(resp.body);
        await _saveAuth(data);
        return null;
      }
      return _extractError(resp.body);
    } catch (e) {
      return e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, String> get authHeaders {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token.value.isNotEmpty) {
      headers['Authorization'] = 'Bearer ${token.value}';
    }
    return headers;
  }

  Future<void> _saveAuth(Map<String, dynamic> data) async {
    final String jwt = data['token'] ?? '';
    token.value = jwt;
    await SharedPreferenceService.setValue('token', jwt);

    // Données de profil utiles côté client
    await SharedPreferenceService.setValue(
      'utilisateurId',
      (data['utilisateurId'] ?? '').toString(),
    );
    await SharedPreferenceService.setValue(
      'nom',
      data['nom']?.toString() ?? '',
    );
    await SharedPreferenceService.setValue(
      'prenom',
      data['prenom']?.toString() ?? '',
    );
    await SharedPreferenceService.setValue(
      'email',
      data['email']?.toString() ?? '',
    );
    await SharedPreferenceService.setValue(
      'telephone',
      data['telephone']?.toString() ?? '',
    );
    await SharedPreferenceService.setValue(
      'role',
      data['role']?.toString() ?? '',
    );
    await SharedPreferenceService.setValue(
      'estVerifie',
      (data['estVerifie'] ?? '').toString(),
    );
  }

  String _extractError(String body) {
    try {
      final Map<String, dynamic> err = jsonDecode(body);
      return (err['error'] ?? err['message'] ?? body).toString();
    } catch (_) {
      return body;
    }
  }
}
