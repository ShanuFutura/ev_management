import 'package:battery_indicator/battery_indicator.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:tts_ble/blue.dart';

import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:tts_ble/widgets/pin.dart';
import 'package:tts_ble/widgets/progress_bar.dart';
// import 'package:tts_ble/widgets/speedo_meter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // brightness: Brightness.dark,
        canvasColor: Colors.white,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final phoneNumberController = TextEditingController();

  final sosMessageController = TextEditingController();

  final TextEditingController controller =
      TextEditingController(text: 'Hello world');

  BluetoothController bluetoothController = BluetoothController();

  bool isHidden = false;
  String speed = '0.0';
  bool isStart = false;
  var chargePrimary = '0';
  var chargeSecondary = '0';
  var time = 0.0;
  var distance = 0.0;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    // final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(.2),
        title: Text('EV'),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     showDialog(
          //         context: context,
          //         builder: (context) {
          //           return AlertDialog(
          //               content: Container(w),
          //               );
          //         });
          //   },
          //   icon: Icon(Icons.bluetooth),
          // )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BluetoothApp(
            controller: bluetoothController,
            onMessage: (p0) async {
              final List<String> dataList = p0.split(',');
              // Fluttertoast.showToast(msg: dataList.toString());
              if (dataList.length > 3) {
                setState(() {
                  speed = dataList[0].toString();
                  chargePrimary = dataList[1].toString();
                  chargeSecondary = dataList[2].toString();
                });
              }
              if (dataList.length > 3) {}
              // print();
              print(
                  'speed : $speed, primary battery $chargePrimary, secondary battery $chargeSecondary');
            },
          ),
          Expanded(
            child: Container(
                child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: CircleAvatar(
                            child: Text(
                              '$speed Km',
                              style: TextStyle(fontSize: deviceWidth * .04),
                            ),
                            radius: deviceWidth * .09,
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextButton.icon(
                          onPressed: () {
                            if (isStart) {
                              setState(() {
                                isStart = false;
                              });
                              time = 0.0;
                              distance = 0.0;
                              bluetoothController.sendMessage('T');
                              Fluttertoast.showToast(msg: 'engine killed');
                            } else {
                              setState(() {
                                isStart = true;
                              });
                              time = 0.0;
                              distance = 0.0;
                              bluetoothController.sendMessage('S');
                              Fluttertoast.showToast(msg: 'engine started');
                            }
                          },
                          icon: Icon(
                            isStart ? Icons.cancel : Icons.bolt,
                            color: Colors.red,
                            // Theme.of(context).primaryColor,
                            size: 50,
                          ),
                          label: Text(isStart ? 'Kill' : 'Start'),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColorLight,
                        radius: (deviceWidth / 2) - 27,
                      ),
                      CircleAvatar(
                        radius: (deviceWidth / 2) - 30,
                        backgroundImage: AssetImage('assets/sc.png'),
                      ),
                      Pin(
                          pinName: 'A',
                          fromLeft: 80,
                          fromTop: 70,
                          onThodal: () {
                            Fluttertoast.showToast(
                                msg: 'Destination changed to A');
                            bluetoothController.sendMessage('8');
                            // print('thottu1');
                          }),
                      Pin(
                        pinName: 'B',
                        fromLeft: 190,
                        fromTop: 180,
                        onThodal: () {
                          Fluttertoast.showToast(
                              msg: 'Destination changed to B');
                          bluetoothController.sendMessage('4');
                          // print('thottu');
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularPercentIndicator(
                          radius: 40.0,
                          lineWidth: 5.0,
                          percent: double.parse('$chargePrimary') / 100,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Primary'),
                              Text("$chargePrimary%"),
                            ],
                          ),
                          progressColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularPercentIndicator(
                          radius: 40.0,
                          lineWidth: 5.0,
                          percent: double.parse('$chargeSecondary') / 100,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Primary'),
                              Text("$chargeSecondary%"),
                            ],
                          ),
                          progressColor: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                  Text(
                    'Distance progress',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  StreamBuilder(
                      stream: Stream.periodic(Duration(milliseconds: 1)),
                      builder: (context, snap) {
                        if (isStart) {
                          time++;
                          distance = distance +
                              ((time * (double.parse(speed))) / 1000000);
                        }

                        print('distance: $distance, time: $time');
                        return ProgressBar(progress: distance / 500);
                      }),
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }
}
