import 'package:tanaye_front_mobile/utils/shared_preference_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString token = ''.obs;
  final RxString errorMessage = ''.obs;

  static const String _baseUrl = 'http://10.0.2.2:9999/api/auth';
  static const Duration _timeout = Duration(seconds: 30);

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future<void> loadToken() async {
    try {
      final stored = await SharedPreferenceService.getValue('token');
      token.value = stored ?? '';
    } catch (e) {
      errorMessage.value = 'Erreur lors du chargement du token: $e';
    }
  }

  Future<void> initialize() async {
    await loadToken();
  }

  void clearError() {
    errorMessage.value = '';
  }

  Future<String?> login(String identifiant, String motDePasse) async {
    if (identifiant.trim().isEmpty || motDePasse.trim().isEmpty) {
      return 'Identifiant et mot de passe requis';
    }

    isLoading.value = true;
    clearError();

    try {
      final resp = await http
          .post(
            Uri.parse('$_baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'identifiant': identifiant.trim(),
              'motDePasse': motDePasse,
            }),
          )
          .timeout(_timeout);

      if (resp.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(resp.body);
        await _saveAuth(data);
        return null;
      }
      return _extractError(resp.body);
    } catch (e) {
      return 'Erreur de connexion: ${e.toString()}';
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
    // Validation des données
    final validationError = _validateRegistrationData(
      nom,
      prenom,
      email,
      telephone,
      motDePasse,
      confirmationMotDePasse,
      role,
    );
    if (validationError != null) {
      return validationError;
    }

    isLoading.value = true;
    clearError();

    try {
      final resp = await http
          .post(
            Uri.parse('$_baseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'nom': nom.trim(),
              'prenom': prenom.trim(),
              'email': email.trim().toLowerCase(),
              'telephone': telephone.trim(),
              'motDePasse': motDePasse,
              'confirmationMotDePasse': confirmationMotDePasse,
              'role': role,
            }),
          )
          .timeout(_timeout);

      if (resp.statusCode == 200) {
        // Le backend ne renvoie pas de token avant vérification
        return null;
      }
      return _extractError(resp.body);
    } catch (e) {
      return 'Erreur lors de l\'inscription: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> verifyAccount({
    required String email,
    required String code,
  }) async {
    if (email.trim().isEmpty || code.trim().isEmpty) {
      return 'Email et code requis';
    }

    isLoading.value = true;
    clearError();

    try {
      final resp = await http
          .post(
            Uri.parse('$_baseUrl/verify'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email.trim().toLowerCase(),
              'code': code.trim(),
            }),
          )
          .timeout(_timeout);

      if (resp.statusCode == 200) {
        return null;
      }
      return _extractError(resp.body);
    } catch (e) {
      return 'Erreur lors de la vérification: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> resendVerification(String email) async {
    if (email.trim().isEmpty) {
      return 'Email requis';
    }

    isLoading.value = true;
    clearError();

    try {
      final resp = await http
          .post(
            Uri.parse('$_baseUrl/resend-code'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email.trim().toLowerCase()}),
          )
          .timeout(_timeout);

      if (resp.statusCode == 200) {
        return null;
      }
      return _extractError(resp.body);
    } catch (e) {
      return 'Erreur lors du renvoi du code: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Les emails sont gérés côté backend via Gmail SMTP

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

  String? _validateRegistrationData(
    String nom,
    String prenom,
    String email,
    String telephone,
    String motDePasse,
    String confirmationMotDePasse,
    String role,
  ) {
    if (nom.trim().isEmpty) return 'Le nom est requis';
    if (prenom.trim().isEmpty) return 'Le prénom est requis';
    if (email.trim().isEmpty) return 'L\'email est requis';
    if (telephone.trim().isEmpty) return 'Le téléphone est requis';
    if (motDePasse.isEmpty) return 'Le mot de passe est requis';
    if (confirmationMotDePasse.isEmpty) {
      return 'La confirmation du mot de passe est requise';
    }
    if (role.trim().isEmpty) return 'Le rôle est requis';

    if (motDePasse != confirmationMotDePasse) {
      return 'Les mots de passe ne correspondent pas';
    }

    if (motDePasse.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }

    if (!_isValidEmail(email)) {
      return 'Format d\'email invalide';
    }

    if (!_isValidPhone(telephone)) {
      return 'Format de téléphone invalide';
    }

    return null;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    // Validation simple pour les numéros de téléphone
    return RegExp(r'^[\+]?[0-9\s\-\(\)]{8,}$').hasMatch(phone);
  }
}
