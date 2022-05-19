import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneNumberField extends StatefulWidget {
  const PhoneNumberField({
    Key key,
    @required this.phoneNumberController,
  }) : super(key: key);

  final TextEditingController phoneNumberController;

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  @override
  getPhoneNumber() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        setState(() {
          widget.phoneNumberController.text =
              value.getString('targetNumber').replaceAll('+91', '') ??
                  'No number added';
        });
      });
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getPhoneNumber();
  }

  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          prefix: Text('+91 '),
          label: Text('Emergency number'),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      controller: widget.phoneNumberController,
    );
  }
}
