import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerProvider with ChangeNotifier {
  final SharedPreferences prefs;
  
  late int _workDuration;
  late int _breakDuration;
  late int _currentSeconds;
  bool _isRunning = false;
  bool _isWorkSession = true;
  Timer? _timer;

  Function? onTimerEnd;

  TimerProvider(this.prefs) {
    _loadSettings();
  }

  void _loadSettings() {
    _workDuration = prefs.getInt('workDuration') ?? 25 * 60;
    _breakDuration = prefs.getInt('breakDuration') ?? 5 * 60;
    _currentSeconds = _workDuration;
  }

  int get currentSeconds => _currentSeconds;
  bool get isRunning => _isRunning;
  bool get isWorkSession => _isWorkSession;

  String get timeLeft {
    int minutes = _currentSeconds ~/ 60;
    int seconds = _currentSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get progress => 1 - (_currentSeconds / (_isWorkSession ? _workDuration : _breakDuration));

  int get workDuration => _workDuration;
  int get breakDuration => _breakDuration;

  void startTimer({Function? onEnd}) {
    if (!_isRunning) {
      _isRunning = true;
      _sessionCompleted = false;
      onTimerEnd = onEnd;
      _timer = Timer.periodic(Duration(seconds: 1), (_) {
        if (_currentSeconds > 0) {
          _currentSeconds--;
          notifyListeners();
        } else {
          stopTimer();
          _sessionCompleted = true;
          if (onTimerEnd != null) {
            onTimerEnd!();
          }
        }
      });
      notifyListeners();
    }
  }

  void startNextSession() {
    if (_sessionCompleted) {
      _switchSession();
      _sessionCompleted = false;
      notifyListeners();
    }
  }

  void pauseTimer() {
    if (_isRunning) {
      _isRunning = false;
      _timer?.cancel();
      notifyListeners();
    }
  }

  void resetTimer() {
    stopTimer();
    _currentSeconds = _isWorkSession ? _workDuration : _breakDuration;
    notifyListeners();
  }

  void stopTimer() {
    _isRunning = false;
    _timer?.cancel();
  }

  void _switchSession() {
    _isWorkSession = !_isWorkSession;
    _currentSeconds = _isWorkSession ? _workDuration : _breakDuration;
    notifyListeners();
  }

  void setWorkDuration(int minutes) {
    _workDuration = minutes * 60;
    prefs.setInt('workDuration', _workDuration);
    if (_isWorkSession && !_isRunning) _currentSeconds = _workDuration;
    notifyListeners();
  }

  void setBreakDuration(int minutes) {
    _breakDuration = minutes * 60;
    prefs.setInt('breakDuration', _breakDuration);
    if (!_isWorkSession && !_isRunning) _currentSeconds = _breakDuration;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool _sessionCompleted = false;
  bool get sessionCompleted => _sessionCompleted;
}