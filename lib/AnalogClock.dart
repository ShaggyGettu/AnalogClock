import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class AnalogClock extends StatefulWidget {
  @override
  _AnalogClockState createState() => _AnalogClockState();

  static Future<DateTime> showAnalogClock({
    @required BuildContext context,
    DateTime dateTime,
  }) async {
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
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Select time',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        dateTime != null
                            ? intl.DateFormat('dd/MM/yyyy').format(dateTime)
                            : '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
                backgroundColor: Colors.white,
                elevation: 0,
                content: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [],
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
