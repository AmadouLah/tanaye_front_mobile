import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanaye_front_mobile/auth/loading_page.dart';
import 'package:tanaye_front_mobile/auth/login_page.dart';
import 'package:tanaye_front_mobile/auth/register_screen.dart';
import 'package:tanaye_front_mobile/auth/verify_code_page.dart';
import 'package:tanaye_front_mobile/home/home_screen.dart';
import 'package:tanaye_front_mobile/router/auth_guard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/loading',
      getPages: [
        GetPage(
          name: '/loading',
          page: () => MyLoadingPage(title: 'Loading Page'),
        ),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(
          name: '/verify',
          page: () {
            final args = Get.arguments as Map<String, dynamic>?;
            final email = args?['email']?.toString() ?? '';
            return VerifyCodePage(email: email);
          },
        ),
        GetPage(
          name: '/home',
          page: () => const HomeScreen(),
          middlewares: [AuthGuard()],
        ),
      ],
    );
  }
}
