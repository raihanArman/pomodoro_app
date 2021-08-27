import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:podomoro_app/widgets/progress_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              'Pomodoro number 2',
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Set: 3',
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularPercentIndicator(
                    radius: 220.0,
                    lineWidth: 15.0,
                    percent: 03.0,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text(
                      '13:42',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                    progressColor: Colors.red,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ProgressIcons(
                    total: 4,
                    done: 3,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
