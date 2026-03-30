import 'dart:async';

import 'package:flutter/material.dart';

import 'home_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _frame = 1;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 120), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _frame = _frame % 8 + 1;
      });
    });

    Future<void>.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeShell()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final frame = _frame.toString().padLeft(2, '0');
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/m3/splash_screen.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFF90CAF9)),
          ),
          Align(
            alignment: const Alignment(0, 0.72),
            child: Image.asset(
              'assets/m3/loading/loading_$frame.png',
              width: 128,
              height: 128,
              errorBuilder: (context, error, stackTrace) => const CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
