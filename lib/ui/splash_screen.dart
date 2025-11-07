import 'dart:async';

import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/ui/onboarding.dart';
import 'package:devkitflutter/ui/domain_login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _second = 3; // set timer for 3 second and then direct to next page
  late final AnimationController _controller;
  late final Animation<double> _rotation;
  late final Animation<double> _scale;
  late final Animation<double> _lift; // vertical float for shadow parallax

  void _startTimer() {
    const period = Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      setState(() {
        _second--;
      });
      if (_second == 0) {
        _cancelFlashsaleTimer();
        _navigateNext();

        // if you use this splash screen on the very first time when you open the page, use below code
        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => OnBoardingPage()), (Route<dynamic> route) => false);
      }
    });
  }

  Future<void> _navigateNext() async {
    final prefs = await SharedPreferences.getInstance();
    final hasOnboarded = prefs.getBool('hasOnboarded') ?? false;
    if (hasOnboarded) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const DomainLoginPage()));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const OnBoardingPage()));
    }
  }

  void _cancelFlashsaleTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  @override
  void initState() {
    // set status bar color to transparent and navigation bottom color to black21
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    // 3D-like animation controller
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat(reverse: true);
    // Subtle tilt only
    _rotation = Tween<double>(begin: -0.06, end: 0.06).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _scale = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _lift = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (_second != 0) {
      _startTimer();
    }
    super.initState();
  }

  @override
  void dispose() {
    _cancelFlashsaleTimer();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PopScope(
      canPop: false,
      child: Container(
        color: Colors.white,
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              // Perspective 3D effect
              final Matrix4 transform = Matrix4.identity()
                ..setEntry(3, 2, 0.0012) // perspective
                ..rotateX(_rotation.value * 0.6)
                ..rotateY(_rotation.value)
                ..scale(_scale.value);

              return Stack(
                alignment: Alignment.center,
                children: [
                  // No rings, no lines — just the animated logo on white
                  Transform.translate(
                    offset: Offset(0, _lift.value),
                    child: Transform(
                      transform: transform,
                      alignment: Alignment.center,
                      child: Image.asset(
                        '$localImagesUrl/efeedor_logo.png',
                        width: MediaQuery.of(context).size.width / 2,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ));
  }
}
