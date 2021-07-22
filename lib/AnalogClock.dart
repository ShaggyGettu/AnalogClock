import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class AnalogClock extends StatefulWidget {
  final double height = 180;
  final double width = 180;
  final ClockType clockType;
  final Function changeHour;
  final TimeOfDay timeOfDay;

  const AnalogClock({
    Key key,
    this.clockType = ClockType.Hours12,
    this.changeHour,
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
    double sectionSize =
        (size.width - amountDots * 50 - (isHour12 ? 100 : 0)) / amountSections;
    print(sectionSize);
    return Visibility(
      child: TextButton(
        onPressed: () => onPressed(),
        child: Text(
          data,
          style: TextStyle(
            fontSize: 20,
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
        ':',
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
    assert(hour12 ||
        hour12Minute ||
        hour12MinuteSecond ||
        hour24 ||
        hour24Minute ||
        hour24MinuteSecond ||
        minute ||
        minuteSecond ||
        second);
    if (dateTime == null) dateTime = DateTime.now();
    ClockType clockType = (hour12 || hour12Minute || hour12MinuteSecond)
        ? ClockType.Hours12
        : null;
    clockType = clockType == null
        ? (hour24 || hour24Minute || hour24MinuteSecond)
            ? ClockType.Hours24
            : null
        : clockType;
    clockType = clockType == null
        ? (minute || minuteSecond)
            ? ClockType.Minutes
            : null
        : clockType;
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
    print(timeOfDay.hour);

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
              height: MediaQuery.of(context2).size.height * 0.1,
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
            content: StatefulBuilder(
              builder: (context3, setState1) {
                Function changeHour = (int hour) {
                  print(timeOfDay);
                  timeOfDay =
                      timeOfDay.replacing(hour: getRealHour(hour, amPmPick));
                  print(timeOfDay);
                  clockType = clockType == ClockType.Hours12 ||
                          clockType == ClockType.Hours24
                      ? (hour12Minute ||
                              hour12MinuteSecond ||
                              hour24Minute ||
                              hour24MinuteSecond)
                          ? ClockType.Minutes
                          : null
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

                return Container(
                  padding: EdgeInsets.only(
                    top: 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            MediaQuery.of(context3).size,
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
                            MediaQuery.of(context3).size,
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
                                minuteSecond,
                            () {
                              clockType = ClockType.Seconds;
                              setState1(() {});
                            },
                            timeOfDay.minute < 10
                                ? '0${timeOfDay.minute}'
                                : '${timeOfDay.minute}',
                            clockType == ClockType.Seconds,
                            MediaQuery.of(context3).size,
                            amountSections,
                            amountDots,
                            hour12 || hour12Minute || hour12MinuteSecond,
                          ),
                          // AM PM pick
                          Visibility(
                            visible:
                                hour12 || hour12Minute || hour12MinuteSecond,
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
                                    height: 30,
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
                                    height: 30,
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
                        clockType: clockType,
                        changeHour: changeHour,
                        timeOfDay: timeOfDay,
                      ),
                      SizedBox(
                        height: 20,
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
          );
        },
      ),
    );
    return dateTime;
  }

  static int getRealHour(int hour, bool amPmPick) =>
      hour == 12 ? 0 : hour + (amPmPick ? 0 : 12);
}

class _AnalogClockState extends State<AnalogClock> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 25,
        right: 25,
        bottom: 0,
      ),
      width: widget.width * 2,
      height: widget.height + 60,
      child: Stack(
        children: [
          Positioned(
            child: CustomPaint(
              size: Size(
                widget.width * 2,
                widget.height + 50,
              ),
              painter: StrokePainter(
                clockType: widget.clockType,
                timeOfDay: widget.timeOfDay,
              ),
            ),
          ),
          ClockNumbers(
            width: widget.width,
            height: widget.height,
            clockType: widget.clockType,
            changeHour: widget.changeHour,
            timeOfDay: widget.timeOfDay,
          ),
        ],
      ),
    );
  }
}

class StrokePainter extends CustomPainter {
  final Size size;
  final ClockType clockType;
  final TimeOfDay timeOfDay;

  StrokePainter({
    Key key,
    this.size,
    this.clockType,
    this.timeOfDay,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(
        size.width / 2,
        size.height / 2,
      ),
      5,
      Paint()..color = Colors.blueAccent,
    );
    drawStroke(canvas, size);
  }

  void drawStroke(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(
        size.width / 2,
        size.height / 2,
      ),
      lastPoint(size),
      Paint()
        ..color = Colors.blueAccent
        ..strokeWidth = 3,
    );
  }

  Offset lastPoint(Size size) {
    double width = 0;
    double height = 0;
    double spacer = 18;
    int hour = timeOfDay.hourOfPeriod;
    switch (clockType) {
      case ClockType.Hours12:
        int w = hour % 3;
        if (hour == 0) {
          width = size.width / 2;
          height = spacer;
        } else if (hour < 3) {
          width = size.width / 2 + (w / 6) * size.width + spacer;
          height = (w / 6) * size.height - spacer;
        } else if (hour == 3) {
          width = size.width * 0.9;
          height = size.height / 2;
        } else if (hour < 6) {
          width = size.width - (w / 6) * size.width + spacer;
          height = size.height / 2 + (w / 6) * size.height + spacer;
        } else if (hour == 6) {
          width = size.width / 2;
          height = size.height - spacer;
        } else if (hour < 9) {
          width = size.width / 2 - (w / 6) * size.width - spacer;
          height = size.height - (w / 6) * size.height + spacer;
        } else if (hour == 9) {
          width = spacer;
          height = size.height / 2;
        } else if (hour < 12) {
          width = (w / 6) * size.width - spacer;
          height = size.height / 2 - (w / 6) * size.height - spacer;
        }
        break;
      case ClockType.Hours24:
        break;
      case ClockType.Minutes:
        break;
      default:
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
  final double width;

  final double height;

  final ClockType clockType;

  final Function changeHour;

  final TimeOfDay timeOfDay;

  ClockNumbers({
    Key key,
    this.width,
    this.height,
    this.clockType = ClockType.Hours12,
    this.changeHour,
    this.timeOfDay,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ClockNumbersState();
}

class _ClockNumbersState extends State<ClockNumbers> {
  final double circleRadius = 48;
  int chosenNumber = 12;

  @override
  initState() {
    chosenNumber =
        widget.timeOfDay.hourOfPeriod == 0 ? 12 : widget.timeOfDay.hourOfPeriod;
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
        numbers = build12HoursNumbers();
        break;
      case ClockType.Minutes:
        // TODO: Handle this case.
        break;
      case ClockType.Seconds:
        // TODO: Handle this case.
        break;
    }
    return Stack(
      children: numbers,
    );
  }

  List<Widget> build12HoursNumbers() {
    List<Widget> numbers = [];
    double width = widget.width / 2;
    double height = widget.height / 2;
    double spacer = 18;
    Function changeHour = () {};
    for (int i = 0; i < 3; i++) {
      // 0-3
      numbers.add(
        Positioned(
          height: circleRadius,
          width: circleRadius,
          top: (i / 6) * widget.height - (i == 0 ? 0 : spacer),
          left: width + (i / 6) * widget.width + (i == 0 ? 0 : spacer),
          child: numberButton(i == 0 ? 12 : i, changeHour),
        ),
      );
      // 3-6
      numbers.add(
        Positioned(
          height: circleRadius,
          width: circleRadius,
          top: height + (i / 6) * widget.height + (i == 0 ? 0 : spacer),
          left: width + ((3 - i) / 6) * widget.width + (i == 0 ? 0 : spacer),
          child: numberButton(i + 3, changeHour),
        ),
      );
      // 6-9
      numbers.add(
        Positioned(
          height: circleRadius,
          width: circleRadius,
          top: height + ((3 - i) / 6) * widget.height + (i == 0 ? 0 : spacer),
          left: width - (i / 6) * widget.width - (i == 0 ? 0 : spacer),
          child: numberButton(i + 6, changeHour),
        ),
      );
      // 9-12
      numbers.add(
        Positioned(
          height: circleRadius,
          width: circleRadius,
          top: height - (i / 6) * widget.height - (i == 0 ? 0 : spacer),
          left: (i / 6) * widget.width - (i == 0 ? 0 : spacer),
          child: numberButton(i + 9, changeHour),
        ),
      );
    }

    return numbers;
  }

  RawMaterialButton numberButton(int number, Function onChange) {
    return RawMaterialButton(
      onPressed: () {
        chosenNumber = number;
        setState(() {});
        widget.changeHour(number);
      },
      fillColor: number == chosenNumber ? Colors.blueAccent : null,
      highlightColor: Colors.blueAccent,
      child: numberText(number),
      shape: CircleBorder(),
    );
  }

  Text numberText(int number) {
    return Text(
      (number).toString(),
      style: TextStyle(
        color: chosenNumber == number ? Colors.white : Colors.black,
        fontSize: 18,
      ),
    );
  }
}
