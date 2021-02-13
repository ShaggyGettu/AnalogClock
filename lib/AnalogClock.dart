import 'package:flutter/material.dart';

class AnalogClock extends StatefulWidget {
  @override
  _AnalogClockState createState() => _AnalogClockState();

  static Future<DateTime> showAnalogClock(BuildContext context) async {
    DateTime dateTime = DateTime.now();
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                titlePadding: EdgeInsets.all(0),
                // Design of the title.
                title: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  height: 60,
                ),
              ),
            ));
    return dateTime;
  }
}

class _AnalogClockState extends State<AnalogClock> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
