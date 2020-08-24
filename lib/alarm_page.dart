import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:vibration/vibration.dart';
import 'package:toast/toast.dart';

class Alarm extends StatefulWidget {
  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> with TickerProviderStateMixin {
  TabController tb;
  int hourAlarm = 0;
  int minAlarm = 0;
  int hour = 0;
  int min = 0;
  int sec = 0;
  bool started = true;
  bool stopped = true;
  bool checkTimer = true;
  int timeForTimer = 0;
  String timeToDisplay = "";

  List splitTimes = [];
  bool startPressed = true;
  bool stopPressed = true;
  bool resetPressed = true;
  var stopWatch = Stopwatch();
  String stopWatchTime = "00:00:00:00";
  final dur = const Duration(milliseconds: 1);

  @override
  void initState() {
    // TODO: implement initState
    tb = TabController(
      length: 3,
      vsync: this,
    );
    super.initState();
  }

  //TIMER FUNCTIONS
  void start() {
    setState(() {
      started = false;
      stopped = false;
    });
    timeForTimer = hour * 60 * 60 + min * 60 + sec;
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (timeForTimer < 1 || checkTimer == false) {
          t.cancel();
          timeToDisplay = "";
          if (timeForTimer == 0) {
            Vibration.vibrate(duration: 1000);
          }
          checkTimer = true;
          started = true;
          stopped = true;
        } else if (timeForTimer < 60) {
          timeToDisplay = timeForTimer.toString();
          timeForTimer = timeForTimer - 1;
          if (timeForTimer == 0) {
            Vibration.vibrate(duration: 1000);
          }
        } else if (timeForTimer < 3600) {
          int m = timeForTimer ~/ 60;
          int s = timeForTimer - (60 * m);
          timeToDisplay = m.toString() + ":" + s.toString();
          timeForTimer = timeForTimer - 1;
          if (timeForTimer == 0) {
            Vibration.vibrate(duration: 1000);
          }
        } else {
          int h = timeForTimer ~/ 3600;
          int t = timeForTimer - (3600 * h);
          int m = t ~/ 60;
          int s = t - (60 * m);
          timeToDisplay =
              h.toString() + ":" + m.toString() + ":" + s.toString();
          timeForTimer = timeForTimer - 1;
          if (timeForTimer == 0) {
            Vibration.vibrate(duration: 1000);
          }
        }
      });
    });
  }

  void stop() {
    setState(() {
      started = true;
      stopped = true;
      checkTimer = false;
    });
  }

  Widget timer() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text("HH"),
                    ),
                    NumberPicker.integer(
                      initialValue: hour,
                      minValue: 0,
                      maxValue: 23,
                      listViewWidth: 60.0,
                      onChanged: (val) {
                        setState(() {
                          hour = val;
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text("MM"),
                    ),
                    NumberPicker.integer(
                      initialValue: min,
                      minValue: 0,
                      listViewWidth: 60.0,
                      maxValue: 59,
                      onChanged: (val) {
                        setState(() {
                          min = val;
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text("SS"),
                    ),
                    NumberPicker.integer(
                      initialValue: sec,
                      minValue: 0,
                      listViewWidth: 60.0,
                      maxValue: 59,
                      onChanged: (val) {
                        setState(() {
                          sec = val;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              timeToDisplay,
              style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text(
                    "Start",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: started ? start : null,
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  child: Text(
                    "Stop",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: stopped ? null : stop,
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //STOPWATCH FUNCTIONS
  void startTimer() {
    Timer(dur, keepRunning);
  }

  void keepRunning() {
    if (stopWatch.isRunning) {
      startTimer();
    }
    setState(() {
      stopWatchTime = stopWatch.elapsed.inHours.toString().padLeft(2, "0") +
          ":" +
          (stopWatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
          ":" +
          (stopWatch.elapsed.inSeconds % 60).toString().padLeft(2, "0") +
          ":" +
          (stopWatch.elapsed.inMilliseconds % 100).toString().padLeft(2, "0");
    });
  }

  void startStopWatch() {
    setState(() {
      startPressed = false;
      stopPressed = false;
      resetPressed = false;
    });
    stopWatch.start();
    startTimer();
  }

  void stopStopWatch() {
    setState(() {
      startPressed = true;
      stopPressed = true;
      resetPressed = true;
    });
    stopWatch.stop();
  }

  void resetStopWatch() {
    setState(() {
      startPressed = true;
      stopPressed = true;
      resetPressed = true;
    });
    stopWatch.stop();
    stopWatch.reset();
    splitTimes = [];
  }

  void splitStopWatch() {
    splitTimes.add(stopWatchTime);
    print(splitTimes);
  }

  Widget stopwatch() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            stopWatchTime,
            style: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text("Start"),
                onPressed: startPressed ? startStopWatch : null,
                color: Colors.green,
              ),
              SizedBox(width: 10),
              RaisedButton(
                child: Text("Stop"),
                onPressed: stopPressed ? null : stopStopWatch,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              RaisedButton(
                child: Text("Reset"),
                onPressed: resetPressed ? null : resetStopWatch,
                color: Colors.lightBlue,
              ),
              SizedBox(width: 10),
              RaisedButton(
                child: Text("Split"),
                onPressed: stopPressed ? null : splitStopWatch,
                color: Colors.blueGrey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  //ALARM FUNCTION

  Widget alarm() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text("HH"),
                  ),
                  NumberPicker.integer(
                    initialValue: hourAlarm,
                    minValue: 0,
                    maxValue: 23,
                    listViewWidth: 60.0,
                    onChanged: (val) {
                      setState(() {
                        hourAlarm = val;
                      });
                    },
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text("HH"),
                  ),
                  NumberPicker.integer(
                    initialValue: minAlarm,
                    minValue: 0,
                    maxValue: 59,
                    listViewWidth: 60.0,
                    onChanged: (val) {
                      setState(() {
                        minAlarm = val;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          RaisedButton(
            child: Text("Set Alarm"),
            onPressed: () {
              Toast.show(
                  "Alarm Set: " +
                      DateTime.now()
                          .add(Duration(minutes: hourAlarm * 60 + minAlarm))
                          .toString(),
                  context,
                  duration: Toast.LENGTH_LONG,
                  gravity: Toast.BOTTOM);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clock"),
        centerTitle: true,
        bottom: TabBar(
          tabs: <Widget>[
            Text("Alarm"),
            Text("Timer"),
            Text("StopWatch"),
          ],
          controller: tb,
          unselectedLabelColor: Colors.white60,
          labelPadding: EdgeInsets.all(10.0),
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          alarm(),
          timer(),
          stopwatch(),
        ],
        controller: tb,
      ),
    );
  }
}
