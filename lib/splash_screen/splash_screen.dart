import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_truecaller/flutter_truecaller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterTruecaller truecaller = FlutterTruecaller();


  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () async {
      bool isInstalled = await DeviceApps.isAppInstalled('com.truecaller');
      if (isInstalled) {
        getTruecallerProfile();
        await truecaller.getProfile();
        FlutterTruecaller.manualVerificationRequired.listen((required) {
          if (required) {
            Navigator.pushReplacementNamed(context, 'truecallerverify');
          } else {
            Navigator.pushReplacementNamed(context, 'home');
          }
        });
      }else{
        Navigator.pushReplacementNamed(context, 'phone');
      }
    });
    super.initState();
  }

  Future getTruecallerProfile() async {
    truecaller.initializeSDK(
      sdkOptions: FlutterTruecallerScope.SDK_OPTION_WITH_OTP,
      footerType: FlutterTruecallerScope.FOOTER_TYPE_ANOTHER_METHOD,
      consentMode: FlutterTruecallerScope.CONSENT_MODE_POPUP,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Lottie.asset("assets/splash/splash_logo.json")),
    );
  }
}
