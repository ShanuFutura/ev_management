import 'package:flutter/material.dart';
// import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_maintained/sms.dart';
import 'package:tts_ble/blue.dart';
import 'package:tts_ble/phone_number_widget.dart';
import 'package:material_color_utilities/material_color_utilities.dart' ;
import 'package:dynamic_color/dynamic_color.dart' ;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return dc.DynamicColorBuilder(builder: (a, b) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // brightness: Brightness.dark,
          canvasColor: Colors.white,
          useMaterial3: true,
          primarySwatch: ColorScheme.
          // primarySwatch: a.primary == null
          //     ? MaterialColor(0xFF93cd48, {
          //         50: a.primary.withOpacity(.1),
          //         100: a.primary.withOpacity(.2),
          //         200: a.primary.withOpacity(.3),
          //         300: a.primary.withOpacity(.4),
          //         400: a.primary.withOpacity(.5),
          //         500: a.primary.withOpacity(.6),
          //         600: a.primary.withOpacity(.7),
          //         700: a.primary.withOpacity(.8),
          //         800: a.primary.withOpacity(.9),
          //         900: a.primary.withOpacity(1),
          //       })
          //     : Colors.blue,
          // primaryColor: a.primary,
          // backgroundColor: a.background,
        ),
        debugShowCheckedModeBanner: false,
        home: Home(),
      );
    });
  }
}

class Home extends StatelessWidget {
  final phoneNumberController = TextEditingController();
  final sosMessageController = TextEditingController();
  final FlutterTts tts = FlutterTts();
  final TextEditingController controller =
      TextEditingController(text: 'Hello world');
  BluetoothController bluetoothController = BluetoothController();

  setSosMessage(String message, String target) async {
    final spref = await SharedPreferences.getInstance();
    spref.setString('targetNumber', target);
    spref.setString('sosMessage', message);
  }

  sendSosMessage() async {
    final spref = await SharedPreferences.getInstance();
    final currentLoc = await Location.instance.getLocation();

    tts.speak('sending emergency message');
    SmsSender().sendSms(SmsMessage(
        spref.getString('targetNumber') ?? '+919995395865',
        'Im in trouble my location is https://www.google.co.in/maps/@${currentLoc.latitude},${currentLoc.longitude},14.15z ,'));
    print(
        'Im in trouble my location is ${currentLoc.latitude},${currentLoc.longitude}');
  }

  Home() {
    print(tts.getLanguages);
    tts.setLanguage('en');
    tts.setSpeechRate(0.4);
  }

// speak(String data){
// tts.speak(data);
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(.2),
        title: Text('INS'),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/bgimg.png',
            // fit: BoxFit.fitWidth,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BluetoothApp(
                controller: bluetoothController,
                onMessage: (p0) async {
                  print('printing from bt $p0');
                  if (p0 == 'R') {
                    tts.speak('obstacle at right');
                  } else if (p0 == 'L') {
                    tts.speak('obstacle at Left');
                  } else if (p0 == 'F') {
                    tts.speak('obstacle at Front');
                  } else if (p0 == 'E') {
                    sendSosMessage();
                  } else {
                    tts.speak('negative');
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: PhoneNumberField(
                    phoneNumberController: phoneNumberController),
              ),
              // TextField(
              //   controller: controller,
              // ),
              ElevatedButton(
                  onPressed: () {
                    // sendSMS(message: 'test message', recipients: ['+919947500227'])
                    //     .onError((error, stackTrace) => '$error')
                    //     .whenComplete(() => print('completed'))
                    //     .then((value) => print('$value done'));
                    // tts.speak(controller.text);
                    SharedPreferences.getInstance()
                        .then((value) => value.setString('targetNumber',
                            '+91${phoneNumberController.text.trim()}'))
                        .then((value) =>
                            Fluttertoast.showToast(msg: 'number saved'));
                  },
                  child: Text('Save number')),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
      // floatingActionButton: dc.DynamicColorBuilder(builder: (a, b) {
      //   return FloatingActionButton(
      //     onPressed: () {
      //       print(a.primary);
      //     },
      //     backgroundColor: a.primary,
      //   );
      // }),
    );
  }
}
