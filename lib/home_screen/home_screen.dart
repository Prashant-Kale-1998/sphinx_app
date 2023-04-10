import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_wake/flutter_screen_wake.dart';
import 'package:http/http.dart' as http;
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var brightness = 0.0;
  bool toggle = false;
  bool isOn =false;
  var data;

  @override
  void initState() {
    apiCall();
    initPlatformBrightness();
    super.initState();
  }

  Future<void> apiCall()async {
    var response = await  http.get(Uri.parse("https://forapi-dc639-default-rtdb.firebaseio.com/.json"));
    print("this is response : "+response.body.toString());
    data = response.body.toString();
  }


  Future<void> initPlatformBrightness() async{
    double brigth;
    try{
      brigth = await FlutterScreenWake.brightness;
    }on PlatformException{
      brigth= 1.0;
    }

    if(!mounted) return;
    setState(() {
      brightness = brigth;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sphinx app"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LiteRollingSwitch(
                  value: false,
                  width: 80,
                  textOn: 'on',
                  textOff: 'off',
                  colorOn: Colors.green.shade400,
                  colorOff: Colors.blueGrey,
                  iconOn: Icons.brightness_6_rounded,
                  iconOff: Icons.power_settings_new,
                  animationDuration: const Duration(milliseconds: 100),
                  onChanged: (bool state) {
                    isOn = state;
                    print('turned ${(state) ? 'on' : 'off'}');
                  },
                  onDoubleTap: () {
                    setState(() {

                    });
                  },
                  onSwipe: () {
                    setState(() {

                    });
                  },
                  onTap: () {
                    setState(() {
                    });
                  },
                ),
                SizedBox(width: 50,),
                ElevatedButton(
                    onPressed: (){
                      Navigator.pushNamed(context, 'map');
                    }, child: Text("Map")),
              ],
            ),
          ),
          isOn? Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("Api Data: "+data),
          ):Container(),
          isOn? Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black26
              ),
                boxShadow: [BoxShadow(color: Colors.black26,spreadRadius: 2,blurRadius: 2)]
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    AnimatedCrossFade(
                      firstChild: Icon(Icons.brightness_7,size: 50,),
                      secondChild: Icon(Icons.brightness_3,size: 50,) ,
                      crossFadeState: toggle ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      duration: Duration(seconds: 1),
                    ),
                    Expanded(
                        child: Slider(value: brightness,
                          onChanged: (value){
                          setState(() {
                            brightness = value;
                            print("this is brightness : "+brightness.toString());
                          });
                          FlutterScreenWake.setBrightness(brightness);
                          if(brightness == 0){
                            toggle = true;
                          }else{
                            toggle = false;
                          }
                    },))
                  ],
                ),
              ],
            ),
          ): Container() ,

        ],
      ),
    );
  }
}
