import 'package:tanaye_front_mobile/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final _identifiantCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  final AuthController _auth = Get.put(AuthController());

  LoginScreen({super.key});

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
                'Connexion',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _identifiantCtrl,
                decoration: InputDecoration(
                  labelText: 'Email ou téléphone',
                  prefixIcon: Icon(Icons.email, color: Colors.grey),
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
              SizedBox(height: 20),
              Obx(
                () =>
                    _auth.isLoading.value
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                          onPressed: () async {
                            final errorMsg = await _auth.login(
                              _identifiantCtrl.text.trim(),
                              _pwdCtrl.text.trim(),
                            );
                            if (errorMsg == null) {
                              Get.offAllNamed('/home');
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
                          child: Text('Se connecter'),
                        ),
              ),
              SizedBox(height: 15),
              TextButton(
                onPressed: () => Get.toNamed('/register'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Pas de compte ? ',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Créer un compte',
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
