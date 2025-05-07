import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nfc_reader_flush/pages/LoginPage.dart';
import 'package:nfc_reader_flush/pages/MainPage.dart';
import 'package:nfc_reader_flush/util/StorageUtils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        String? token = await StorageUtils.get('token');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => (token != null && token.isNotEmpty)
                  ? const MainPage()
                  : const LoginPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'images/animations/splash.json',
          controller: _controller,
          onLoaded: (composition) {
            _controller.duration = composition.duration;
            _controller.forward();
          },
        ),
      ),
    );
  }
}
