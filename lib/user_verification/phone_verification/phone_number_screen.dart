import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sphinx_app/user_verification/phone_verification/phone_number_verification_screen.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({Key? key}) : super(key: key);
  static String verify = "";
  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  var phone = "", email = "",firstname="",lastname="";
  bool emailVerified = false;
  Timer? timer;

  @override
  void initState() {
    countryController.text = "+91";
    super.initState();
  }

  sendVerificationMail(String email)async{
    try{

      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: "password");

      emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      if(!emailVerified){
          final user = FirebaseAuth.instance.currentUser!;
          await user.sendEmailVerification();
          timer =Timer.periodic(
              Duration(seconds: 3), (_)=> checkEmailverification());
      }

      const snackBar = SnackBar(content: Text('verification link have been send on your email!'),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }catch(e){
      print(e.toString());
      const snackBar = SnackBar(content: Text('Error'),backgroundColor: Colors.red,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailverification() async{
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if(emailVerified){timer?.cancel();}
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
                Image.asset(
                  "assets/icons/mobile_number.png",
                  height: 200,
                  width: 200,
                ),
                Text(
                  "User Details",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "We need to register your Name, Email, Phone number before getting started..!",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
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
                              border: InputBorder.none, hintText: "First Name"),
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
                                  border: InputBorder.none, hintText: "Last Name"),
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
                          onChanged: (value) {
                            email = value;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: "Email"),
                        ),
                      )),
                       Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: TextButton(
                          onPressed: (){
                            if(email.isEmpty){
                              const snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Enter email!'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }else{
                              sendVerificationMail(email);
                            }
                          },
                          child: Text(
                            emailVerified? "verified":"verify",
                            style: TextStyle(color:emailVerified? Colors.green:Colors.red),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                          width: 40,
                          child: TextField(
                            controller: countryController,
                            decoration: InputDecoration(border: InputBorder.none),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "|",
                        style: TextStyle(fontSize: 33, color: Colors.grey),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: TextField(
                        onChanged: (value) {
                          phone = value;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Phone"),
                      ))
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
                      if (firstnameController.text.isEmpty||firstname=="") {
                        const snackBar = SnackBar(
                          content: Text('Enter Your First Name!'),
                          backgroundColor: Colors.red,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      else if (lastnameController.text.isEmpty||lastname=="") {
                        const snackBar = SnackBar(
                          content: Text('Enter Your Last Name!'),
                          backgroundColor: Colors.red,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }

                      else if (email.isEmpty || !emailVerified ) {
                        const snackBar = SnackBar(
                          content: Text('First verify your email!'),
                          backgroundColor: Colors.red,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (phone.length != 10) {
                          const snackBar = SnackBar(
                            content: Text('Enter Phone Number.'),
                            backgroundColor: Colors.red,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }else{

                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: '${countryController.text + phone}',
                            verificationCompleted:
                                (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException e) {},
                            codeSent: (String verificationId, int? resendToken) {
                              PhoneNumberScreen.verify = verificationId;
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>PhoneNumberVerificationScreen(firstname: firstname,lastname: lastname, email: email, phone: phone)));
                            },
                            codeAutoRetrievalTimeout: (String verificationId) {},
                          );
                        }
                      },
                    child: Text("Send OTP"),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                )
              ],
            ),
          ),
        ),

    );
  }
}
