import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro/providers/timer_provider.dart';
import 'package:pomodoro/providers/theme_provider.dart';
import 'package:numberpicker/numberpicker.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
        elevation: 0,
      ),
      body: Consumer2<TimerProvider, ThemeProvider>(
        builder: (context, timerProvider, themeProvider, child) {
          return ListView(
            children: [
              _buildSettingCard(
                context,
                title: 'Work Duration',
                child: Text('${timerProvider.workDuration ~/ 60} minutes', style: Theme.of(context).textTheme.bodyLarge),
                onTap: () => _showDurationPicker(context, true),
              ),
              _buildSettingCard(
                context,
                title: 'Break Duration',
                child: Text('${timerProvider.breakDuration ~/ 60} minutes', style: Theme.of(context).textTheme.bodyLarge),
                onTap: () => _showDurationPicker(context, false),
              ),
              _buildSettingCard(
                context,
                title: 'Theme',
                child: DropdownButton<ThemeMode>(
                  value: themeProvider.themeMode,
                  onChanged: (ThemeMode? newValue) {
                    if (newValue != null) {
                      themeProvider.setThemeMode(newValue);
                    }
                  },
                  items: ThemeMode.values.map((ThemeMode mode) {
                    return DropdownMenuItem<ThemeMode>(
                      value: mode,
                      child: Text(mode.toString().split('.').last, style: Theme.of(context).textTheme.bodyLarge),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSettingCard(BuildContext context, {required String title, required Widget child, VoidCallback? onTap}) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(title, style: Theme.of(context).textTheme.titleLarge),
        trailing: child,
        onTap: onTap,
      ),
    );
  }

  void _showDurationPicker(BuildContext context, bool isWorkDuration) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isWorkDuration ? 'Set Work Duration' : 'Set Break Duration',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Consumer<TimerProvider>(
          builder: (context, timerProvider, child) {
            return NumberPicker(
              minValue: 1,
              maxValue: 60,
              value: isWorkDuration ? timerProvider.workDuration ~/ 60 : timerProvider.breakDuration ~/ 60,
              onChanged: (value) => isWorkDuration
                  ? timerProvider.setWorkDuration(value)
                  : timerProvider.setBreakDuration(value),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK', style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}