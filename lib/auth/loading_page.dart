import 'dart:async';

import 'package:tanaye_front_mobile/auth/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class MyLoadingPage extends StatefulWidget {
  const MyLoadingPage({super.key, required this.title});

  final String title;

  @override
  State<MyLoadingPage> createState() => _MyLoadingPageState();
}

class _MyLoadingPageState extends State<MyLoadingPage> {
  @override
  void initState() {
    super.initState();
    loadAnimation();
  }

  Future<Timer> loadAnimation() async {
    return Timer(const Duration(seconds: 5), onLoaded);
  }

  onLoaded() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => SplashScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.title),
      ),
      body: Center(
        child: Lottie.asset("assets/lotties/DeliveryCourier.json", repeat: false),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
