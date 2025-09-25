import 'package:tanaye_front_mobile/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final authCtrl = Get.put(AuthController());
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(Duration(seconds: 5));
    await authCtrl.loadToken();
    final hasToken = authCtrl.token.value.isNotEmpty;
    Get.offNamed(hasToken ? '/home' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
