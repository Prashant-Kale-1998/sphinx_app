import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_truecaller/flutter_truecaller.dart';

class TrueCallerVerification extends StatefulWidget {
  const TrueCallerVerification({Key? key}) : super(key: key);

  @override
  State<TrueCallerVerification> createState() => _TrueCallerVerificationState();
}

class _TrueCallerVerificationState extends State<TrueCallerVerification> {
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  final FlutterTruecaller truecaller = FlutterTruecaller();
  bool emailVerified = false,otpRequired=false;
  var firstname="",lastname="",mobile="",otp="";


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: TextField(
                    onChanged: (value) {
                      mobile = value;
                    },
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Phone"),
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: TextField(
                            onChanged: (value){
                              firstname=value;
                            },
                            controller: firstnameController,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: "FirstName"),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: TextField(
                            onChanged: (value){
                              lastname=value;
                            },
                            controller: lastnameController,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: "Name"),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                      otpRequired=await truecaller.requestVerification(mobile);
                  },
                  child: Text("Send OTP"),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green.shade600,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              if(otpRequired)SizedBox(
                height: 20,
              ),
              if(otpRequired)Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: TextField(
                            onChanged: (value){
                              otp=value;
                            },
                            controller: otpController,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: "OTP"),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                      if(otpRequired){
                        await truecaller.verifyOtp(firstname, lastname, otp);
                      }else{
                        Future.delayed(Duration(seconds: 3));
                        Navigator.pushNamed(context, 'done');
                      }
                  },
                  child: Text("Verify OTP"),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green.shade600,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
