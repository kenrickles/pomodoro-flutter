import 'package:flutter/material.dart';
import 'package:pomodoro/screens/home_screen.dart';
import 'package:pomodoro/providers/theme_provider.dart';
import 'package:pomodoro/providers/timer_provider.dart';
import 'package:pomodoro/providers/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (context) => TimerProvider(prefs)),
        ChangeNotifierProvider(create: (context) => TaskProvider(prefs)),
      ],
      child: PomodoroApp(),
    ),
  );
}

class PomodoroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Pomodoro Timer',
      theme: themeProvider.currentTheme,
      darkTheme: themeProvider.darkTheme,
      themeMode: themeProvider.themeMode,
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}