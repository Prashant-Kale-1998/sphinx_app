import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DoneScreen extends StatefulWidget {
  const DoneScreen({Key? key}) : super(key: key);

  @override
  State<DoneScreen> createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3),(){
      Navigator.pushReplacementNamed(context, 'home');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
          child: Lottie.asset("assets/splash/done.json")
      ),
    );
  }
}
