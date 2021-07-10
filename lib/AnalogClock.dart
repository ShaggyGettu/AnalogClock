import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class AnalogClock extends StatefulWidget {
  final double radius = 180;

  const AnalogClock({Key key}) : super(key: key);
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
            elevation: 0,
            content: Container(
              height: 408,
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnalogClock(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      textDirection: TextDirection.rtl,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        FlatButton(
                          minWidth: 24,
                          highlightColor: Colors.white,
                          splashColor: Colors.white,
                          padding: EdgeInsets.zero,
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "OK",
                            style: TextStyle(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                        FlatButton(
                          highlightColor: Colors.white,
                          splashColor: Colors.white,
                          minWidth: 24,
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "CANCEL",
                            style: TextStyle(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
      padding: EdgeInsets.only(
        top: 77,
        left: 37,
        right: 37,
        bottom: 77,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      width: widget.radius * 2,
      height: widget.radius * 2,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(
              widget.radius,
              widget.radius,
            ),
            painter: ClockPainter(
              size: Size(widget.radius, widget.radius),
            ),
          ),
          ClockNumbers(
            radius: widget.radius,
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
    return Stack(
      children: numbers,
    );
  }

  List<Widget> build12HoursNumbers() {
    List<Widget> numbers = [];
    double width = widget.radius / 2;
    double height = 0;
    double spacer = 18;
    for (int i = 0; i < 3; i++) {
      // 0-3
      numbers.add(
        Positioned(
          height: 26,
          width: 26,
          top: height + (i / 6) * widget.radius - (i == 0 ? 0 : spacer),
          left: width + (i / 6) * widget.radius + (i == 0 ? 0 : spacer),
          child: numberButton(i == 0 ? 12 : i),
        ),
      );
      // 3-6
      numbers.add(
        Positioned(
          height: 26,
          width: 26,
          top: width + (i / 6) * widget.radius + (i == 0 ? 0 : spacer),
          left: width + ((3 - i) / 6) * widget.radius + (i == 0 ? 0 : spacer),
          child: numberButton(i + 3),
        ),
      );
      // 6-9
      numbers.add(
        Positioned(
          height: 26,
          width: 26,
          top: width + ((3 - i) / 6) * widget.radius + (i == 0 ? 0 : spacer),
          left: width - (i / 6) * widget.radius - (i == 0 ? 0 : spacer),
          child: numberButton(i + 6),
        ),
      );
      // 9-12
      numbers.add(
        Positioned(
          height: 26,
          width: 26,
          top: width - (i / 6) * widget.radius - (i == 0 ? 0 : spacer),
          left: height + (i / 6) * widget.radius - (i == 0 ? 0 : spacer),
          child: numberButton(i + 9),
        ),
      );
    }

    return numbers;
  }

  RawMaterialButton numberButton(int number) {
    return RawMaterialButton(
      onPressed: () => print(number),
      hoverElevation: 8,
      child: numberText(number),
      shape: CircleBorder(),
    );
  }

  Text numberText(int number) {
    return Text(
      (number).toString(),
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
      ),
    );
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
