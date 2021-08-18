import 'dart:math';

import 'package:flutter/material.dart';

class AnalogClock extends StatefulWidget {
  final double radius = 140;
  final double width;
  final double height;
  final ClockType clockType;
  final Function changeHour;
  final Function changeMinute;
  final TimeOfDay timeOfDay;
  static const double _minimumDialogWidth = 350;
  static const double _minimumDialogHeight = 350;

  const AnalogClock({
    Key key,
    this.clockType = ClockType.Hours12,
    this.width,
    this.height,
    this.changeHour,
    this.changeMinute,
    this.timeOfDay,
  }) : super(key: key);
  @override
  _AnalogClockState createState() => _AnalogClockState();

  static Visibility buildSection(
    bool visible,
    Function onPressed,
    String data,
    bool colorType,
    Size size,
    int amountSections,
    int amountDots,
    bool isHour12,
  ) {
    double sectionSize = 55;
    return Visibility(
      child: TextButton(
        onPressed: () => onPressed(),
        child: Text(
          data,
          style: TextStyle(
            fontSize: 24,
            color: colorType ? Colors.blue[500] : Colors.black,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            colorType ? Colors.blue[50] : Colors.black12,
          ),
          minimumSize:
              MaterialStateProperty.all(Size(sectionSize, sectionSize)),
        ),
      ),
      visible: visible,
    );
  }

  static Visibility twoDots(bool isMinute) {
    return Visibility(
      visible: isMinute,
      child: Text(
        ' : ',
        style: TextStyle(
          fontFamily: 'bold',
          fontSize: 24,
        ),
      ),
    );
  }

  static Future<DateTime> showAnalogClock({
    @required BuildContext context,
    DateTime dateTime,
    double screenWidth = 280,
    double screenHeight = 350,
    bool hour12 = false,
    bool hour24 = false,
    bool hour12Minute = false,
    bool hour24Minute = false,
    bool hour12MinuteSecond = false,
    bool hour24MinuteSecond = false,
    bool minute = false,
    bool minuteSecond = false,
    bool second = false,
  }) async {
    if (screenHeight < 380) screenHeight = 380;
    if (screenWidth < 280) screenWidth = 280;
    if (dateTime == null) dateTime = DateTime.now();
    ClockType clockType = (hour12 || hour12Minute || hour12MinuteSecond)
        ? ClockType.Hours12
        : null;
    clockType = clockType ??
        ((hour24 || hour24Minute || hour24MinuteSecond)
            ? ClockType.Hours24
            : null);
    clockType =
        clockType ?? ((minute || minuteSecond) ? ClockType.Minutes : null);
    clockType = clockType ?? (second ? ClockType.Seconds : null);
    assert(hour12 ||
        hour12Minute ||
        hour12MinuteSecond ||
        hour24 ||
        hour24Minute ||
        hour24MinuteSecond ||
        minute ||
        minuteSecond ||
        second);
    assert(clockType != null);
    TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dateTime);

    /// If true - AM
    /// If false - PM
    bool amPmPick = timeOfDay.hour < 11;
    int amountSections = hour12MinuteSecond
        ? 4
        : hour12Minute || hour24MinuteSecond || minuteSecond
            ? 3
            : hour12
                ? 2
                : 1;
    int amountDots = hour12MinuteSecond || hour24MinuteSecond
        ? 2
        : hour12Minute || hour24Minute || minuteSecond
            ? 1
            : 0;
    await showDialog(
      context: context,
      builder: (context1) => Dialog(
        insetPadding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: StatefulBuilder(
          builder: (context3, setState1) {
            Function changeHour = (int hour) {
              timeOfDay = timeOfDay.replacing(
                hour: getRealHour(hour, amPmPick),
                minute: timeOfDay.minute,
              );
              clockType = (hour12Minute ||
                      hour12MinuteSecond ||
                      hour24Minute ||
                      hour24MinuteSecond)
                  ? ClockType.Minutes
                  : null;
              dateTime = DateTime(
                dateTime.year,
                dateTime.month,
                dateTime.day,
                timeOfDay.hour,
                timeOfDay.minute,
              );
              if (clockType == null) {
                Navigator.of(context).pop();
              }
              setState1(() {});
            };

            Function changeMinute = (int minute) {
              if (minute == 60) minute = 0;
              timeOfDay =
                  timeOfDay.replacing(hour: timeOfDay.hour, minute: minute);
              // clockType =
              //     (hour12MinuteSecond || hour24MinuteSecond || minuteSecond)
              //         ? ClockType.Seconds
              //         : null;
              dateTime = DateTime(
                dateTime.year,
                dateTime.month,
                dateTime.day,
                timeOfDay.hour,
                timeOfDay.minute,
              );
              if (clockType == null) {
                Navigator.of(context).pop();
              }
              setState1(() {});
            };
            return Container(
              width: screenWidth,
              height: screenHeight,
              padding: EdgeInsets.only(
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Hours section
                      buildSection(
                        hour12 ||
                            hour12Minute ||
                            hour12MinuteSecond ||
                            hour24 ||
                            hour24Minute ||
                            hour24MinuteSecond,
                        () {
                          clockType =
                              hour12 || hour12Minute || hour12MinuteSecond
                                  ? ClockType.Hours12
                                  : ClockType.Hours24;
                          setState1(() {});
                        },
                        timeOfDay.hourOfPeriod < 10 &&
                                timeOfDay.hourOfPeriod != 0
                            ? '0${timeOfDay.hourOfPeriod}'
                            : '${timeOfDay.hourOfPeriod == 0 ? 12 : timeOfDay.hourOfPeriod}',
                        clockType == ClockType.Hours12 ||
                            clockType == ClockType.Hours24,
                        MediaQuery.of(context).size,
                        amountSections,
                        amountDots,
                        hour12 || hour12Minute || hour12MinuteSecond,
                      ),
                      // Two dots :
                      twoDots(hour12Minute ||
                          hour12MinuteSecond ||
                          hour24Minute ||
                          hour24MinuteSecond),
                      // Minutes section
                      buildSection(
                        hour12Minute ||
                            hour12MinuteSecond ||
                            hour24Minute ||
                            hour24MinuteSecond ||
                            minute ||
                            minuteSecond,
                        () {
                          clockType = ClockType.Minutes;
                          setState1(() {});
                        },
                        timeOfDay.minute < 10
                            ? '0${timeOfDay.minute}'
                            : '${timeOfDay.minute}',
                        clockType == ClockType.Minutes,
                        MediaQuery.of(context).size,
                        amountSections,
                        amountDots,
                        hour12 || hour12Minute || hour12MinuteSecond,
                      ),
                      // Two dots :
                      twoDots(hour12MinuteSecond ||
                          hour24MinuteSecond ||
                          minuteSecond),
                      // Seconds section
                      buildSection(
                        hour12MinuteSecond ||
                            hour24MinuteSecond ||
                            minuteSecond ||
                            second,
                        () {
                          clockType = ClockType.Seconds;
                          setState1(() {});
                        },
                        timeOfDay.minute < 10
                            ? '0${timeOfDay.minute}'
                            : '${timeOfDay.minute}',
                        clockType == ClockType.Seconds,
                        MediaQuery.of(context).size,
                        amountSections,
                        amountDots,
                        hour12 || hour12Minute || hour12MinuteSecond,
                      ),
                      // AM PM pick
                      Visibility(
                        visible: hour12 || hour12Minute || hour12MinuteSecond,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // AM section
                              Container(
                                width: 40,
                                height: 27.5,
                                color: amPmPick ? Colors.blue[50] : null,
                                child: TextButton(
                                  onPressed: () {
                                    amPmPick = true;
                                    setState1(() {});
                                  },
                                  child: Text(
                                    'AM',
                                    style: TextStyle(
                                      color: amPmPick
                                          ? Colors.blue[500]
                                          : Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              // PM section
                              Container(
                                width: 40,
                                height: 28,
                                color: !amPmPick ? Colors.blue[50] : null,
                                child: TextButton(
                                  style: ButtonStyle(),
                                  onPressed: () {
                                    amPmPick = false;
                                    setState1(() {});
                                  },
                                  child: Text(
                                    'PM',
                                    style: TextStyle(
                                      color: !amPmPick
                                          ? Colors.blue[500]
                                          : Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AnalogClock(
                    width: buildRadius(screenWidth, screenHeight - 184),
                    height: buildRadius(screenWidth, screenHeight - 184),
                    clockType: clockType,
                    changeHour: changeHour,
                    changeMinute: changeMinute,
                    timeOfDay: timeOfDay,
                  ),
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
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "OK",
                            style: TextStyle(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                        TextButton(
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
            );
          },
        ),
      ),
    );
    return dateTime;
  }

  static double buildRadius(double height, double width) => min(width, height);

  static int getRealHour(int hour, bool amPmPick) => amPmPick
      ? hour == 12
          ? 0
          : hour
      : hour == 12
          ? hour
          : hour + 12;
  // hour == 12 ? 0 : hour + (amPmPick ? 0 : 12);
}

class _AnalogClockState extends State<AnalogClock> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width * 1.2,
      height: widget.height * 1.2,
      child: Stack(
        children: [
          Positioned(
            child: CustomPaint(
              size: Size(
                widget.width * 1.2,
                widget.height * 1.2,
              ),
              painter: StrokePainter(
                containerSize: Size(
                  widget.width * 1.2,
                  widget.height * 1.2,
                ),
                clockType: widget.clockType,
                timeOfDay: widget.timeOfDay,
              ),
            ),
          ),
          ClockNumbers(
            diameter: widget.width,
            clockType: widget.clockType,
            change: widget.clockType == ClockType.Hours12
                ? widget.changeHour
                : widget.changeMinute,
            changeMinute: widget.changeMinute,
            timeOfDay: widget.timeOfDay,
          ),
        ],
      ),
    );
  }
}

class StrokePainter extends CustomPainter {
  final Size containerSize;
  final ClockType clockType;
  final TimeOfDay timeOfDay;

  StrokePainter({
    Key key,
    this.clockType,
    this.timeOfDay,
    this.containerSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double diameter = containerSize.width - 10;
    double height = containerSize.height - 10;
    canvas.drawCircle(
      Offset(
        diameter / 2,
        height / 2,
      ),
      5,
      Paint()..color = Colors.blueAccent,
    );
    drawStroke(canvas, size, diameter);
  }

  void drawStroke(Canvas canvas, Size size, double diameter) {
    canvas.drawLine(
      Offset(
        diameter / 2,
        diameter / 2,
      ),
      lastPoint(diameter),
      Paint()
        ..color = Colors.blueAccent
        ..strokeWidth = 3,
    );
  }

  Offset lastPoint(double diameter) {
    double width = 0;
    double height = 0;
    double radius = diameter / 2;
    int hour = timeOfDay.hourOfPeriod;
    switch (clockType) {
      case ClockType.Hours24:
        // TODO: Handle this case.
        break;
      case ClockType.Hours12:
        width = radius + sin((pi / 30) * hour * 5) * radius;
        height = radius - cos((pi / 30) * hour * 5) * radius;

        break;
      case ClockType.Minutes:
        int minute = timeOfDay.minute;
        width = radius + sin((pi / 30) * minute) * radius;
        height = radius - cos((pi / 30) * minute) * radius;
        break;
      case ClockType.Seconds:
        // TODO: Handle this case.
        break;
    }
    return Offset(width, height);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// The type of the showing clock.
enum ClockType {
  Hours24,
  Hours12,
  Minutes,
  Seconds,
}

class ClockNumbers extends StatefulWidget {
  final double diameter;

  final ClockType clockType;

  final Function change;

  final Function changeMinute;

  final TimeOfDay timeOfDay;

  ClockNumbers({
    Key key,
    this.diameter,
    this.clockType = ClockType.Hours12,
    this.change,
    this.changeMinute,
    this.timeOfDay,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ClockNumbersState();
}

class _ClockNumbersState extends State<ClockNumbers> {
  final double shrinkCircleRadius = 22;
  final double circleRadius = 33;
  double circleCenter;
  int chosenNumber = 12;

  @override
  initState() {
    circleCenter = circleRadius / 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> numbers = [];
    switch (widget.clockType) {
      case ClockType.Hours24:
        // TODO: Handle this case.
        break;
      case ClockType.Hours12:
        chosenNumber = widget.timeOfDay.hourOfPeriod == 0
            ? 12
            : widget.timeOfDay.hourOfPeriod;
        numbers = build12HoursNumbers();
        break;
      case ClockType.Minutes:
        chosenNumber = widget.timeOfDay.minute;
        chosenNumber = chosenNumber == 0 ? 60 : chosenNumber;
        numbers = buildMinutesNumbers();
        break;
      case ClockType.Seconds:
        // TODO: Handle this case.
        break;
    }
    return Stack(
      children: numbers,
    );
  }

  RawMaterialButton numberButton(
      int number, Function onChange, ClockType clockType) {
    bool isSmall = number % 5 != 0 &&
        (clockType == ClockType.Minutes || clockType == ClockType.Seconds);
    var blueAccent =
        isSmall ? Colors.blueAccent.withOpacity(0.65) : Colors.blueAccent;
    return RawMaterialButton(
      onPressed: () {
        chosenNumber = number;
        setState(() {});
        onChange(number);
      },
      elevation: 0,
      fillColor: number == chosenNumber ? blueAccent : null,
      highlightColor: Colors.blueAccent[100],
      focusColor: Colors.blueAccent[50],
      child: isSmall ? null : numberText(number, clockType),
      shape: CircleBorder(),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      constraints: BoxConstraints(
          maxWidth: chosenNumber == number ? 30 : 20,
          maxHeight: chosenNumber == number ? 30 : 20),
    );
  }

  Text numberText(int number, ClockType clockType) {
    String text = number.toString();
    if (clockType == ClockType.Minutes || clockType == ClockType.Seconds)
      text = number % 5 == 0 ? text : '·';
    return Text(
      text,
      style: TextStyle(
        color: chosenNumber == number ? Colors.white : Colors.black,
        fontSize: number % 5 != 0 &&
                (clockType == ClockType.Minutes ||
                    clockType == ClockType.Seconds)
            ? 15
            : 14,
        fontWeight: number % 5 != 0 &&
                (clockType == ClockType.Minutes ||
                    clockType == ClockType.Seconds)
            ? FontWeight.bold
            : null,
      ),
    );
  }

  List<Widget> build12HoursNumbers() {
    List<Widget> numbers = [];
    double radius = widget.diameter / 2;
    double positionedWidth = 30, positionedHeight = 30;
    for (int i = 5; i <= 60; i = i + 5) {
      numbers.add(
        Positioned(
            left: radius + sin((pi / 30) * i) * radius,
            top: radius - cos((pi / 30) * i) * radius,
            width: positionedWidth,
            height: positionedHeight,
            child: numberButton(
              i ~/ 5,
              widget.change,
              ClockType.Hours12,
            )),
      );
    }
    return numbers;
  }

  List<Widget> buildMinutesNumbers() {
    List<Widget> numbers = [];
    double radius = widget.diameter / 2;
    double positionedWidth = 30, positionedHeight = 30;
    for (int i = 1; i <= 60; i++) {
      numbers.add(
        Positioned(
          left: radius + sin((pi / 30) * i) * radius,
          top: (radius - cos((pi / 30) * i) * radius),
          width: positionedWidth,
          height: positionedHeight,
          child: numberButton(i, widget.change, ClockType.Minutes),
        ),
      );
    }
    return numbers;
  }
}
