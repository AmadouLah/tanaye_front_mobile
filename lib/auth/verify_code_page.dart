import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:tanaye_front_mobile/controller/auth_controller.dart';

class VerifyCodePage extends StatefulWidget {
  final String email;

  const VerifyCodePage({super.key, required this.email});

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final _codeCtrl = TextEditingController();
  final AuthController _auth = Get.put(AuthController());
  int _seconds = 20;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 20);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds <= 1) {
        t.cancel();
        setState(() => _seconds = 0);
      } else {
        setState(() => _seconds -= 1);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vérification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Un code a été envoyé à ${widget.email}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _codeCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Code de vérification',
                prefixIcon: Icon(Icons.verified),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () =>
                  _auth.isLoading.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: () async {
                          final code = _codeCtrl.text.trim();
                          if (code.isEmpty) return;
                          final err = await _auth.verifyAccount(
                            email: widget.email,
                            code: code,
                          );
                          if (err == null) {
                            Get.snackbar(
                              'Succès',
                              'Compte vérifié, vous pouvez vous connecter',
                            );
                            Get.offAllNamed('/login');
                          } else {
                            Get.snackbar(
                              'Erreur',
                              err,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                        child: const Text('Valider'),
                      ),
            ),
            const SizedBox(height: 8),
            Obx(
              () =>
                  _auth.isLoading.value
                      ? const SizedBox.shrink()
                      : TextButton(
                        onPressed:
                            _seconds == 0
                                ? () async {
                                  final err = await _auth.resendVerification(
                                    widget.email,
                                  );
                                  if (err == null) {
                                    Get.snackbar(
                                      'Envoyé',
                                      'Nouveau code envoyé',
                                    );
                                    _startTimer();
                                  } else {
                                    Get.snackbar(
                                      'Erreur',
                                      err,
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  }
                                }
                                : null,
                        child: Text(
                          _seconds == 0
                              ? 'Renvoyer le code'
                              : 'Renvoyer dans $_seconds s',
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
