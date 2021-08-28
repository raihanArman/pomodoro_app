import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:podomoro_app/model/pomodoro_status.dart';
import 'package:podomoro_app/utils/constants.dart';
import 'package:podomoro_app/widgets/custom_button.dart';
import 'package:podomoro_app/widgets/progress_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

const _btnTextStart = 'Start Pomodoro';
const _btnTextResumePomodoro = 'Resume Pomodoro';
const _btnTextResumeBreak = 'Resume Break';
const _btnTextStartShortBreak = 'Take Short Break';
const _btnTextStartLongBreak = 'Take Long Break';
const _btnTextStartNewSet = 'Start New Set';
const _btnTextPause = 'Pause';
const _btnTextReset = 'Reset';

class _HomePageState extends State<HomePage> {
  static AudioCache players = AudioCache();

  int remainingTime = pomodoroTotalTime;
  String mainBtnText = _btnTextStart;
  PomodoroStatus pomodoroStatus = PomodoroStatus.pausedPomodoro;
  Timer? _timer;
  int pomodoroNum = 0;
  int setNum = 0;

  @override
  void InitState() {
    super.initState();
    players.load('bell.mp3');
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'Pomodoro number : $pomodoroNum',
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Set: $setNum',
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularPercentIndicator(
                    radius: 220.0,
                    lineWidth: 15.0,
                    percent: _getPomodoroPercentage(),
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text(
                      _secondsToFormatedString(remainingTime),
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                    progressColor: statusColor[pomodoroStatus],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ProgressIcons(
                    total: pomodoroPerSet,
                    done: pomodoroNum - (setNum * pomodoroPerSet),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    statusDescription[pomodoroStatus]!,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ButtonTheme(
                    minWidth: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        _mainButtonPressed();
                      },
                      child: Text(mainBtnText, style: TextStyle(fontSize: 15)),
                    ),
                  ),
                  // CustomButton(
                  //     onTap: () {
                  //       print('terpencet');
                  //       _mainButtonPressed();
                  //     },
                  //     text: mainBtnText),
                  ButtonTheme(
                    minWidth: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        _resetButtonPressed();
                      },
                      child:
                          Text(_btnTextReset, style: TextStyle(fontSize: 15)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _secondsToFormatedString(int seconds) {
    int roundedMinutes = seconds ~/ 60;
    int remainingSeconds = seconds - (roundedMinutes * 60);
    String remainingSecondsFormated;

    if (remainingSeconds < 10) {
      remainingSecondsFormated = '0$remainingSeconds';
    } else {
      remainingSecondsFormated = remainingSeconds.toString();
    }

    return '$roundedMinutes:$remainingSecondsFormated';
  }

  _pauseShortBreakCountdown() {
    pomodoroStatus = PomodoroStatus.pausedShortBreak;
    _pauseBreakCountdown();
  }

  _pauseLongBreakCountdown() {
    pomodoroStatus = PomodoroStatus.pausedLongBreak;
    _pauseBreakCountdown();
  }

  _pauseBreakCountdown() {
    _cancelTimer();
    setState(() {
      mainBtnText = _btnTextResumeBreak;
    });
  }

  _getPomodoroPercentage() {
    int totalTime;
    switch (pomodoroStatus) {
      case PomodoroStatus.pausedPomodoro:
        totalTime = pomodoroTotalTime;
        break;
      case PomodoroStatus.runningPomodoro:
        totalTime = pomodoroTotalTime;
        break;
      case PomodoroStatus.runningShortBreak:
        totalTime = shortBreakTime;
        break;
      case PomodoroStatus.pausedShortBreak:
        totalTime = shortBreakTime;
        break;
      case PomodoroStatus.runningLongBreak:
        totalTime = longBreakTime;
        break;
      case PomodoroStatus.pausedLongBreak:
        totalTime = longBreakTime;
        break;
      case PomodoroStatus.setFinished:
        totalTime = pomodoroTotalTime;
        break;
    }

    double percentage = (totalTime - remainingTime) / totalTime;
    return percentage;
  }

  _mainButtonPressed() {
    switch (pomodoroStatus) {
      case PomodoroStatus.pausedPomodoro:
        _startPomodoroCountdown();
        break;
      case PomodoroStatus.runningPomodoro:
        _pausePomodoroCountdown();
        break;
      case PomodoroStatus.runningShortBreak:
        _pauseShortBreakCountdown();
        break;
      case PomodoroStatus.pausedShortBreak:
        _startShortBreak();
        break;
      case PomodoroStatus.runningLongBreak:
        _pauseLongBreakCountdown();
        break;
      case PomodoroStatus.pausedLongBreak:
        _startLongBreak();
        break;
      case PomodoroStatus.setFinished:
        setNum++;
        _startPomodoroCountdown();
        break;
    }
  }

  _startPomodoroCountdown() {
    pomodoroStatus = PomodoroStatus.runningPomodoro;
    _cancelTimer();

    _timer = Timer.periodic(
        Duration(seconds: 1),
        (timer) => {
              if (remainingTime > 0)
                {
                  setState(() {
                    remainingTime--;
                    mainBtnText = _btnTextPause;
                  })
                }
              else
                {
                  pomodoroNum++,
                  _cancelTimer(),
                  if (pomodoroNum % pomodoroPerSet == 0)
                    {
                      pomodoroStatus = PomodoroStatus.pausedLongBreak,
                      setState(() {
                        remainingTime = longBreakTime;
                        mainBtnText = _btnTextStartLongBreak;
                      })
                    }
                  else
                    {
                      pomodoroStatus = PomodoroStatus.pausedShortBreak,
                      setState(() {
                        remainingTime = shortBreakTime;
                        mainBtnText = _btnTextStartShortBreak;
                      })
                    }
                }
            });
  }

  _startShortBreak() {
    pomodoroStatus = PomodoroStatus.runningShortBreak;
    setState(() {
      mainBtnText = _btnTextPause;
    });
    _cancelTimer();
    _timer = Timer.periodic(
        Duration(seconds: 1),
        (timer) => {
              if (remainingTime > 0)
                {
                  setState(() {
                    remainingTime--;
                  })
                }
              else
                {
                  _playSound(),
                  remainingTime = pomodoroTotalTime,
                  _cancelTimer(),
                  pomodoroStatus = PomodoroStatus.pausedPomodoro,
                  setState(() {
                    mainBtnText = _btnTextStart;
                  })
                }
            });
  }

  _startLongBreak() {
    pomodoroStatus = PomodoroStatus.runningLongBreak;
    setState(() {
      mainBtnText = _btnTextPause;
    });
    _cancelTimer();
    _timer = Timer.periodic(
        Duration(seconds: 1),
        (timer) => {
              if (remainingTime > 0)
                {
                  setState(() {
                    remainingTime--;
                  })
                }
              else
                {
                  _playSound(),
                  remainingTime = pomodoroTotalTime,
                  _cancelTimer(),
                  pomodoroStatus = PomodoroStatus.setFinished,
                  setState(() {
                    mainBtnText = _btnTextStartNewSet;
                  })
                }
            });
  }

  _pausePomodoroCountdown() {
    pomodoroStatus = PomodoroStatus.pausedPomodoro;
    _cancelTimer();
    setState(() {
      mainBtnText = _btnTextResumePomodoro;
    });
  }

  _resetButtonPressed() {
    pomodoroNum = 0;
    setNum = 0;
    _cancelTimer();
    _stopCountdown();
  }

  _stopCountdown() {
    pomodoroStatus = PomodoroStatus.pausedPomodoro;
    setState(() {
      mainBtnText = _btnTextStart;
      remainingTime = pomodoroTotalTime;
    });
  }

  _cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  _playSound() {
    players.play('bell.mp3');
  }
}
