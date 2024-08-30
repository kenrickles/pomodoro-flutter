import 'package:flutter/material.dart';
import 'package:pomodoro_app/theme/app_theme.dart';
import 'package:provider/provider.dart';

class ColorSchemeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: List.generate(AppTheme.themes.length, (index) {
        return GestureDetector(
          onTap: () => themeProvider.setTheme(index),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.themes[index].primaryColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: themeProvider.currentTheme == AppTheme.themes[index]
                    ? Colors.white
                    : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: themeProvider.currentTheme == AppTheme.themes[index]
                ? Icon(Icons.check, color: Colors.white)
                : null,
          ),
        );
      }),
    );
  }
}