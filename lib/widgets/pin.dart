import 'package:flutter/material.dart';

class Pin extends StatelessWidget {
  Pin(
      {@required String this.pinName,
      @required double this.fromLeft,
      @required double this.fromTop,
      @required Function this.onThodal,
      this.kalar = Colors.white,
      Key key})
      : super(key: key);
  String pinName;
  double fromLeft;
  double fromTop;
  Function onThodal;
  Color kalar;

  @override
  Widget build(BuildContext context) {
    

    return Positioned(
      top: fromTop,
      left: fromLeft,
      child: InkWell(
        onTap: onThodal,
        child: Row(
          children: [
            Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Google_Maps_pin.svg/585px-Google_Maps_pin.svg.png',
              height: 40,
              width: 30,
            ),
            Card(
              color: kalar,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  pinName,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
