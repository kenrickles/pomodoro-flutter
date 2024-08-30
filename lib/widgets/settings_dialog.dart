import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro_app/providers/timer_provider.dart';

class SettingsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    return AlertDialog(
      title: Text('Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDurationSetting(
            context,
            'Work Duration',
            timerProvider.workDuration ~/ 60,
            (value) => timerProvider.setWorkDuration(value),
          ),
          SizedBox(height: 20),
          _buildDurationSetting(
            context,
            'Break Duration',
            timerProvider.breakDuration ~/ 60,
            (value) => timerProvider.setBreakDuration(value),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Close'),
        ),
      ],
    );
  }

  Widget _buildDurationSetting(
    BuildContext context,
    String label,
    int initialValue,
    Function(int) onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        DropdownButton<int>(
          value: initialValue,
          items: List.generate(60, (index) => index + 1)
              .map((int value) => DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value min'),
                  ))
              .toList(),
          onChanged: (value) => onChanged(value!),
        ),
      ],
    );
  }
}