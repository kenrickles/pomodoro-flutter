import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro_app/providers/timer_provider.dart';

class TimerDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              timerProvider.timeLeft,
              style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              timerProvider.isWorkSession ? 'Work Session' : 'Break Time',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            LinearProgressIndicator(
              value: timerProvider.progress,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                timerProvider.isWorkSession ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}