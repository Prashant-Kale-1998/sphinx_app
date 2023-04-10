import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:sphinx_app/user_verification/phone_verification/phone_number_screen.dart';

class PhoneNumberVerificationScreen extends StatefulWidget {
  final String firstname;
  final String lastname;
  final String email;
  final String phone;
  const PhoneNumberVerificationScreen({Key? key,required this.firstname,required this.lastname,required this.email,required this.phone}) : super(key: key);

  @override
  State<PhoneNumberVerificationScreen> createState() => _PhoneNumberVerificationScreenState();
}

class _PhoneNumberVerificationScreenState extends State<PhoneNumberVerificationScreen> {

  final FirebaseAuth auth = FirebaseAuth.instance;

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: Colors.black),
    ),
  );

  var code = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("/users").child("phone_"+widget.phone);

    return  Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent,elevation: 0,leading: IconButton(onPressed:() {
        Navigator.pop(context);
      },icon: Icon(Icons.arrow_back_ios_rounded,color: Colors.black,),),),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/phone_verification.png",
                height: 200,
                width: 200,
              ),
              Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "We need to register your phone number before getting started..!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Pinput(
                length: 6,
                showCursor: true,
                onChanged: (value){
                  code=value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async{
                    try{
                      // Create a PhoneAuthCredential with the code
                      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: PhoneNumberScreen.verify, smsCode: code);

                      // Sign the user in (or link) with the credential
                      await auth.signInWithCredential(credential);

                      await ref.set({
                        "firstname": widget.firstname,
                        "lastname": widget.lastname,
                        "email": widget.email,
                        "phone": widget.phone
                      });

                      const snackBar = SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('User is Created.'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.pushNamed(context, 'done');
                    }catch(e){
                      const snackBar = SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Wrong OTP.'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    },
                  child: Text("Verify phone number"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Row(
                children: [
                  TextButton(onPressed: (){
                    Navigator.pushNamedAndRemoveUntil(context, "phone", (route) => false);
                  }, child: Text("Edit Phone Number ?",style: TextStyle(color: Colors.black),)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
