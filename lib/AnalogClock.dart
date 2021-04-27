import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class AnalogClock extends StatefulWidget {
  final double radius;

  const AnalogClock({
    Key key,
    this.radius,
  }) : super(key: key);
  @override
  _AnalogClockState createState() => _AnalogClockState();

  static Future<DateTime> showAnalogClock({
    @required BuildContext context,
    DateTime dateTime,
  }) async {
    if (dateTime == null) dateTime = DateTime.now();
    await showDialog(
      context: context,
      builder: (context1) => StatefulBuilder(
        builder: (context2, setState) {
          print(MediaQuery.of(context2).size);
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
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
                    intl.DateFormat('dd/MM/yyyy').format(dateTime),
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
            content: Container(
              child: AnalogClock(
                radius: MediaQuery.of(context2).size.width,
              ),
            ),
          );
        },
      ),
    );
    return dateTime;
  }
}

class _AnalogClockState extends State<AnalogClock> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          ClockNumbers(
            radius: widget.radius,
          ),
          CustomPaint(
            size: Size(
              widget.radius,
              widget.radius,
            ),
            painter: ClockPainter(
              size: Size(widget.radius, widget.radius),
            ),
          ),
        ],
      ),
    );
  }
}

/// The type of the showing clock.
enum ClockType {
  Hours24,
  Hours12,
  Minutes,
}

class ClockNumbers extends StatefulWidget {
  /// The size of the rounded numbers, `width` diameter.
  final double radius;
  final ClockType clockType;

  ClockNumbers({
    Key key,
    this.radius,
    this.clockType = ClockType.Hours12,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ClockNumbersState();
}

class _ClockNumbersState extends State<ClockNumbers> {
  @override
  Widget build(BuildContext context) {
    List<Widget> numbers = [];
    switch (widget.clockType) {
      case ClockType.Hours24:
        // TODO: Handle this case.
        break;
      case ClockType.Hours12:
        numbers = build12HoursNumbers();
        break;
      case ClockType.Minutes:
        // TODO: Handle this case.
        break;
    }
    return Container(
      child: Stack(
        children: numbers,
      ),
    );
  }

  List<Widget> build12HoursNumbers() {
    List<Widget> numbers = [];

    numbers.add(
      Positioned(
        top: 0,
        left: widget.radius / 4,
        child: FlatButton(
          onPressed: null,
          child: Text(
            '12',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
    for (int i = 1; i <= 2; i++) {
      numbers.add(
        Positioned(
          top: widget.radius / 2 * (i / 3),
          left: widget.radius / 2 * ((12 - i - 1) / 12),
          child: FlatButton(
            child: Text(
              i.toString(),
              style: TextStyle(fontSize: 16),
            ),
            onPressed: null,
          ),
        ),
      );
      // int realNumber = i + pow(2, (3 - i));
      // numbers.add(
      //   Positioned(
      //     top: widget.size.height * (realNumber / 12),
      //     left: widget.size.width * (i / 6),
      //     child: FlatButton(
      //       child: Text(
      //         (realNumber).toString(),
      //         style: TextStyle(fontSize: 16),
      //       ),
      //       onPressed: null,
      //     ),
      //   ),
      // );
    }
    // numbers.add(
    //   Positioned(
    //     top: widget.size.height / 2,
    //     left: widget.size.width / 2,
    //     child: FlatButton(
    //       onPressed: null,
    //       child: Text(
    //         '3',
    //         style: TextStyle(fontSize: 16),
    //       ),
    //     ),
    //   ),
    // );
    return numbers;
  }
}

class ClockPainter extends CustomPainter {
  final Size size;

  ClockPainter({this.size});
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    canvas.drawLine(
        Offset(size.width / 2, size.height / 2),
        Offset(size.width * 0.75, size.height * 0.75),
        Paint()
          ..color = Colors.black
          ..strokeWidth = 4);
    canvas.drawLine(
        Offset(size.width / 2, size.height / 2),
        Offset(size.width * 0.6, size.height * 0.6),
        Paint()
          ..color = Colors.red
          ..strokeWidth = 8);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}
