import 'package:analog_clock_widget/AnalogClock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  DateTime dateTime;

  void initState() {
    super.initState();
    dateTime = DateTime.now();
  }

  Future<void> _incrementCounter() async {
    print(MediaQuery.of(context).size);

    dateTime = await AnalogClock.showAnalogClock(
      context: context,
      dateTime: DateTime.now().subtract(Duration(days: 3)),
      hour24MinuteSecond: true,
      screenWidth: 1,
      screenHeight: 1,
    );
    print(dateTime);
    // TimeOfDay time;
    // time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    String hour = dateTime.hour < 10 ? '0${dateTime.hour}' : '${dateTime.hour}';
    String minute =
        dateTime.minute < 10 ? '0${dateTime.minute}' : '${dateTime.minute}';
    String second =
        dateTime.second < 10 ? '0${dateTime.second}' : '${dateTime.second}';
    print(MediaQuery.of(context).size);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$hour:$minute:$second',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        renderOverlay: false,
        // overlayOpacity: 0,
        children: _timePickerOptions(),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        icon: Icons.access_time,
        activeIcon: Icons.close,
      ),
    );
  }

  List<SpeedDialChild> _timePickerOptions() {
    return [
      SpeedDialChild(
        child: Center(
          child: Text(
            'hour12MinuteSecond',
            style: TextStyle(
              fontSize: 8,
              color: Colors.blue,
            ),
          ),
        ),
        onTap: () async {
          DateTime dateTime1 = await AnalogClock.showAnalogClock(
            context: context,
            dateTime: dateTime,
            hour12MinuteSecond: true,
          );
          dateTime = dateTime1 ?? dateTime;
          setState(() {});
        },
      ),
      SpeedDialChild(
        child: Center(
          child: Text(
            'hour12Minute',
            style: TextStyle(
              fontSize: 8,
              color: Colors.blue,
            ),
          ),
        ),
        onTap: () async {
          DateTime dateTime1 = await AnalogClock.showAnalogClock(
            context: context,
            dateTime: dateTime,
            hour12Minute: true,
          );
          dateTime = dateTime1 ?? dateTime;
          setState(() {});
        },
      ),
      SpeedDialChild(
        child: Center(
          child: Text(
            'hour12',
            style: TextStyle(
              fontSize: 8,
              color: Colors.blue,
            ),
          ),
        ),
        onTap: () async {
          DateTime dateTime1 = await AnalogClock.showAnalogClock(
            context: context,
            dateTime: dateTime,
            hour12: true,
          );
          dateTime = dateTime1 ?? dateTime;
          setState(() {});
        },
      ),
      SpeedDialChild(
        child: Center(
          child: Text(
            'hour24MinuteSecond',
            style: TextStyle(
              fontSize: 8,
              color: Colors.blue,
            ),
          ),
        ),
        onTap: () async {
          DateTime dateTime1 = await AnalogClock.showAnalogClock(
            context: context,
            dateTime: dateTime,
            hour24MinuteSecond: true,
          );
          dateTime = dateTime1 ?? dateTime;
          setState(() {});
        },
      ),
      SpeedDialChild(
        child: Center(
          child: Text(
            'hour24Minute',
            style: TextStyle(
              fontSize: 8,
              color: Colors.blue,
            ),
          ),
        ),
        onTap: () async {
          DateTime dateTime1 = await AnalogClock.showAnalogClock(
            context: context,
            dateTime: dateTime,
            hour24Minute: true,
          );
          dateTime = dateTime1 ?? dateTime;
          setState(() {});
        },
      ),
      SpeedDialChild(
        child: Center(
          child: Text(
            'hour24',
            style: TextStyle(
              fontSize: 8,
              color: Colors.blue,
            ),
          ),
        ),
        onTap: () async {
          DateTime dateTime1 = await AnalogClock.showAnalogClock(
            context: context,
            dateTime: dateTime,
            hour24: true,
          );
          dateTime = dateTime1 ?? dateTime;
          setState(() {});
        },
      ),
      SpeedDialChild(
        child: Center(
          child: Text(
            'minuteSecond',
            style: TextStyle(
              fontSize: 8,
              color: Colors.blue,
            ),
          ),
        ),
        onTap: () async {
          DateTime dateTime1 = await AnalogClock.showAnalogClock(
            context: context,
            dateTime: dateTime,
            minuteSecond: true,
          );
          dateTime = dateTime1 ?? dateTime;
          setState(() {});
        },
      ),
      SpeedDialChild(
        child: Center(
          child: Text(
            'minute',
            style: TextStyle(
              fontSize: 8,
              color: Colors.blue,
            ),
          ),
        ),
        onTap: () async {
          DateTime dateTime1 = await AnalogClock.showAnalogClock(
            context: context,
            dateTime: dateTime,
            minute: true,
          );
          dateTime = dateTime1 ?? dateTime;
          setState(() {});
        },
      ),
      SpeedDialChild(
        child: Center(
          child: Text(
            'second',
            style: TextStyle(
              fontSize: 8,
              color: Colors.blue,
            ),
          ),
        ),
        onTap: () async {
          DateTime dateTime1 = await AnalogClock.showAnalogClock(
            context: context,
            dateTime: dateTime,
            second: true,
          );
          dateTime = dateTime1 ?? dateTime;
          setState(() {});
        },
      ),
    ];
  }
}
