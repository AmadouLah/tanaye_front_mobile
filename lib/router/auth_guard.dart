import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanaye_front_mobile/controller/auth_controller.dart';

class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth =
        Get.isRegistered<AuthController>()
            ? Get.find<AuthController>()
            : Get.put(AuthController());
    final hasToken = auth.token.value.isNotEmpty;
    return hasToken ? null : const RouteSettings(name: '/login');
  }
}
