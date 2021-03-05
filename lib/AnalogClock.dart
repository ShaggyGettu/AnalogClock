import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class AnalogClock extends StatefulWidget {
  final double width;
  final double height;

  const AnalogClock({Key key, this.width, this.height}) : super(key: key);
  @override
  _AnalogClockState createState() => _AnalogClockState();

  static Future<DateTime> showAnalogClock({
    @required BuildContext context,
    DateTime dateTime,
  }) async {
    if (dateTime == null) dateTime = DateTime.now();
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
          content: AnalogClock(
            width: 360,
            height: 360,
          ),
        ),
      ),
    );
    return dateTime;
  }
}

class _AnalogClockState extends State<AnalogClock> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          ClockNumbers(size: Size(widget.width, widget.height)),
          CustomPaint(
            size: Size(
              widget.width,
              widget.height,
            ),
            painter: ClockPainter(
              size: Size(widget.width, widget.height),
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
  final Size size;
  final ClockType clockType;

  ClockNumbers({
    Key key,
    this.size,
    this.clockType,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ClockNumbersState();
}

class _ClockNumbersState extends State<ClockNumbers> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Positioned(
            bottom: widget.size.height * (5 / 6),
            left: widget.size.width * (1 / 6),
            child: IconButton(
              icon: Icon(Icons.eleven_mp),
              onPressed: null,
            ),
          ),
          Positioned(
            bottom: widget.size.height * (4 / 6),
            left: widget.size.width * (2 / 6),
            child: IconButton(
              icon: Icon(Icons.ten_k),
              onPressed: null,
            ),
          ),
        ],
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
