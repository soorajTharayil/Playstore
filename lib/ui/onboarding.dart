import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/library/sk_onboarding_screen/sk_onboarding_model.dart';
import 'package:devkitflutter/library/sk_onboarding_screen/sk_onboarding_screen.dart';
import 'package:devkitflutter/ui/domain_login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final pages = [
    SkOnboardingModel(
      title: 'Share Your Feedback',
      description:
          'Tell us about your experience with our healthcare services.',
      titleColor: Colors.black,
      descripColor: const Color(0xFF929794),
      imageFromUrl: 'assets/images/onboarding_images1.png',
    ),
    SkOnboardingModel(
      title: 'Rate Our Care',
      description:
          'Help us improve by rating the quality of treatment and services.',
      titleColor: Colors.black,
      descripColor: const Color(0xFF929794),
      imageFromUrl: 'assets/images/onboarding_images2.png',
    ),
    SkOnboardingModel(
      title: 'Ensure Quality',
      description:
          'Your feedback drives better care and healthcare management.',
      titleColor: Colors.black,
      descripColor: const Color(0xFF929794),
      imageFromUrl: 'assets/images/onboarding_images3.png',
    ),
    SkOnboardingModel(
      title: 'Thank You!',
      description:
          'Thank you for helping us deliver exceptional healthcare services.',
      titleColor: Colors.black,
      descripColor: const Color(0xFF929794),
      imageFromUrl: 'assets/images/onboarding_images4.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SKOnboardingScreen(
        bgColor: Colors.white,
        themeColor: assentColor,
        pages: pages,
        skipClicked: (value) {
          //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DomainLoginPage()));
        },
        getStartedClicked: (value) {
          //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DomainLoginPage()));
        },
      ),
    ));
  }
}
