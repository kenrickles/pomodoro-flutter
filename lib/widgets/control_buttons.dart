import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro_app/providers/timer_provider.dart';

class ControlButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            if (timerProvider.isRunning) {
              timerProvider.pauseTimer();
            } else {
              timerProvider.startTimer();
            }
          },
          child: Icon(
            timerProvider.isRunning ? Icons.pause : Icons.play_arrow,
            size: 32,
          ),
          style: ElevatedButton.styleFrom(
            primary: timerProvider.isRunning ? Colors.orange : Colors.green,
            padding: EdgeInsets.all(24),
          ),
        ),
        SizedBox(width: 20),
        ElevatedButton(
          onPressed: () => timerProvider.resetTimer(),
          child: Icon(Icons.refresh, size: 32),
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
            padding: EdgeInsets.all(24),
          ),
        ),
      ],
    );
  }
}