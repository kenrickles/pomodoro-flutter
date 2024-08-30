import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme {
  static final List<ThemeData> themes = [
    _createTheme(Colors.blue, 'Blue'),
    _createTheme(Colors.green, 'Green'),
    _createTheme(Colors.purple, 'Purple'),
    _createTheme(Color(0xFFF9E4B7), 'Beige'),
    _createTheme(Color(0xFFFFD1DC), 'Pink'),
    _createTheme(Color(0xFFF5F5F5), 'Light'),
  ];

  static ThemeData _createTheme(Color primaryColor, String themeName, {bool isDark = false}) {
    return ThemeData(
      primarySwatch: MaterialColor(primaryColor.value, {
        50: primaryColor.withOpacity(0.1),
        100: primaryColor.withOpacity(0.2),
        200: primaryColor.withOpacity(0.3),
        300: primaryColor.withOpacity(0.4),
        400: primaryColor.withOpacity(0.5),
        500: primaryColor.withOpacity(0.6),
        600: primaryColor.withOpacity(0.7),
        700: primaryColor.withOpacity(0.8),
        800: primaryColor.withOpacity(0.9),
        900: primaryColor.withOpacity(1.0),
      }),
      brightness: isDark ? Brightness.dark : Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: GoogleFonts.poppinsTextTheme(isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(20),
          elevation: 5,
        ),
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
      ),
    );
  }

  static ThemeData createDarkTheme(Color primaryColor) {
    return _createTheme(primaryColor, 'Dark', isDark: true);
  }
}

class ThemeProvider with ChangeNotifier {
  final SharedPreferences prefs;
  int _currentThemeIndex;
  bool _isDarkMode;

  ThemeProvider(this.prefs) {
    _currentThemeIndex = prefs.getInt('themeIndex') ?? 0;
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
  }

  ThemeData get currentTheme => AppTheme.themes[_currentThemeIndex];
  ThemeData get darkTheme => AppTheme.createDarkTheme(currentTheme.primaryColor);
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  bool get isDarkMode => _isDarkMode;

  void setTheme(int index) {
    if (index >= 0 && index < AppTheme.themes.length) {
      _currentThemeIndex = index;
      prefs.setInt('themeIndex', index);
      notifyListeners();
    }
  }

  void toggleThemeMode() {
    _isDarkMode = !_isDarkMode;
    prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }
}