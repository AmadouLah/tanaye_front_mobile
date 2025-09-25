import 'package:tanaye_front_mobile/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  final _nomCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telephoneCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  final _confirmPwdCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final AuthController _auth = Get.put(AuthController());

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Inscription',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nomCtrl,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _prenomCtrl,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _emailCtrl,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Colors.grey),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _telephoneCtrl,
                decoration: InputDecoration(
                  labelText: 'Téléphone',
                  prefixIcon: Icon(Icons.phone, color: Colors.grey),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _pwdCtrl,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: Icon(Icons.lock, color: Colors.grey),
                ),
                obscureText: true,
              ),
              SizedBox(height: 15),
              TextField(
                controller: _confirmPwdCtrl,
                decoration: InputDecoration(
                  labelText: 'Confirmer mot de passe',
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                ),
                obscureText: true,
              ),
              SizedBox(height: 15),
              TextField(
                controller: _roleCtrl,
                decoration: InputDecoration(
                  labelText: 'Rôle (ex: CLIENT)',
                  prefixIcon: Icon(Icons.badge, color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              Obx(
                () =>
                    _auth.isLoading.value
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                          onPressed: () async {
                            final errorMsg = await _auth.register(
                              nom: _nomCtrl.text.trim(),
                              prenom: _prenomCtrl.text.trim(),
                              email: _emailCtrl.text.trim(),
                              telephone: _telephoneCtrl.text.trim(),
                              motDePasse: _pwdCtrl.text.trim(),
                              confirmationMotDePasse:
                                  _confirmPwdCtrl.text.trim(),
                              role: _roleCtrl.text.trim(),
                            );
                            if (errorMsg == null) {
                              Get.offAllNamed('/login');
                            } else {
                              Get.snackbar(
                                'Erreur',
                                errorMsg,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('S\'inscrire'),
                        ),
              ),
              SizedBox(height: 15),
              TextButton(
                onPressed: () => Get.toNamed('/login'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Déjà un compte ? ',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Se connecter',
                      style: TextStyle(color: Colors.purple),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
