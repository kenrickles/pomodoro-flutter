import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  final SharedPreferences prefs;

  ThemeProvider(this.prefs) {
    _loadTheme();
    _loadColorPalette();
  }

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  int _currentPaletteIndex = 0;
  int get currentPaletteIndex => _currentPaletteIndex;

  static const List<Map<String, Color>> colorPalettes = [
    {
      'primary': Color(0xFFDC143C),    // Crimson Red
      'secondary': Color(0xFFB22222),  // Firebrick Red
      'tertiary': Color(0xFFFF4500),   // Orange Red
    },
    {
      'primary': Color(0xFFFF8008),    // Orange
      'secondary': Color(0xFFFFC837),  // Orange
      'tertiary': Color(0xFFFFA500),   // Orange
    },
    {
      'primary': Color(0xFF000000),    // Black
      'secondary': Color(0xFF333333),  // Dark Gray
      'tertiary': Color(0xFF666666),   // Medium Gray
    },
    {
      'primary': Color(0xFF642B73),    // Purple
      'secondary': Color(0xFFC6426E),  // Purple
      'tertiary': Color(0xFF8E44AD),   // Purple
    },
    {
      'primary': Color(0xFF4A00E0),    // Royal Purple
      'secondary': Color(0xFF8E2DE2),  // Royal Purple
      'tertiary': Color(0xFF6A0DAD),   // Royal Purple
    },
    {
      'primary': Color(0xFF1A2980),    // Ocean Blue
      'secondary': Color(0xFF26D0CE),  // Ocean Blue
      'tertiary': Color(0xFF1F5F8B),   // Ocean Blue
    },
    {
      'primary': Color(0xFF000046),    // Deep Ocean
      'secondary': Color(0xFF1CB5E0),  // Deep Ocean
      'tertiary': Color(0xFF0077BE),   // Deep Ocean
    },
    {
      'primary': Color(0xFF2C3E50),    // Midnight Blue
      'secondary': Color(0xFF4CA1AF),  // Midnight Blue
      'tertiary': Color(0xFF34495E),   // Midnight Blue
    },
    {
      'primary': Color(0xFF134E5E),    // Emerald Green
      'secondary': Color(0xFF71B280),  // Emerald Green
      'tertiary': Color(0xFF45A29E),   // Emerald Green
    },
    {
      'primary': Color(0xFF56ab2f),    // Lush Meadow
      'secondary': Color(0xFFa8e063),  // Lush Meadow
      'tertiary': Color(0xFF32CD32),   // Lush Meadow
    },
  ];

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void _loadTheme() {
    final themeModeString = prefs.getString('themeMode');
    if (themeModeString != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == themeModeString,
        orElse: () => ThemeMode.system,
      );
    }
    notifyListeners();
  }

  void _loadColorPalette() {
    _currentPaletteIndex = prefs.getInt('colorPaletteIndex') ?? 0;  // Default to 0 (the new red palette)
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    prefs.setString('themeMode', mode.toString());
    notifyListeners();
  }

  void setColorPalette(int index) {
    if (index >= 0 && index < colorPalettes.length) {
      _currentPaletteIndex = index;
      prefs.setInt('colorPaletteIndex', index);
      notifyListeners();
    }
  }

  ThemeData get currentTheme => _buildThemeData(isDarkMode ? Brightness.dark : Brightness.light);

  ThemeData get darkTheme => _buildThemeData(Brightness.dark);

  ThemeData _buildThemeData(Brightness brightness) {
    final colors = colorPalettes[_currentPaletteIndex];
    final baseTextColor = brightness == Brightness.light ? Colors.black : Colors.white;
    final surfaceColor = brightness == Brightness.light ? Colors.white : Color(0xFF303030);

    return ThemeData(
      primaryColor: colors['primary'],
      colorScheme: ColorScheme(
        primary: colors['primary']!,
        secondary: colors['secondary']!,
        tertiary: colors['tertiary']!,
        surface: surfaceColor,
        background: brightness == Brightness.light ? Colors.white : Color(0xFF121212),
        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: baseTextColor,
        onBackground: baseTextColor,
        onError: Colors.white,
        brightness: brightness,
      ),
      scaffoldBackgroundColor: brightness == Brightness.light ? Colors.white : Color(0xFF121212),
      textTheme: TextTheme(
        headlineLarge: TextStyle(color: baseTextColor, fontSize: 28, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: baseTextColor, fontSize: 24, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: baseTextColor, fontSize: 16),
        bodyMedium: TextStyle(color: baseTextColor, fontSize: 14),
      ),
      brightness: brightness,
    );
  }
}