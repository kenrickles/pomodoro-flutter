import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro/providers/timer_provider.dart';
import 'package:pomodoro/providers/theme_provider.dart';
import 'package:pomodoro/providers/task_provider.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

const double MAX_WIDTH = 1200.0;
const double MAX_CONTENT_WIDTH = 800.0;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _taskController = TextEditingController();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 5));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _handleTimerEnd(BuildContext context, TimerProvider timerProvider) {
    _confettiController.play();

    _showBrowserNotification(timerProvider.isWorkSession ? 'Focus Time Ended!' : 'Break Time Ended!');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        final nextSession = timerProvider.isWorkSession ? 'Break' : 'Focus';
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            timerProvider.isWorkSession ? 'Focus Time Ended!' : 'Break Time Ended!',
            style: theme.textTheme.headlineSmall!.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            timerProvider.isWorkSession
                ? 'Great job! Ready for a break?'
                : 'Break\'s over. Ready to focus again?',
            style: theme.textTheme.bodyLarge!.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text(
                'Start $nextSession Session',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                timerProvider.startNextSession();
                timerProvider.startTimer(onEnd: () => _handleTimerEnd(context, timerProvider));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showBrowserNotification(String message) {
    if (kIsWeb) {
      print('Browser Notification: $message');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer3<TimerProvider, ThemeProvider, TaskProvider>(
        builder: (context, timerProvider, themeProvider, taskProvider, child) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: MAX_CONTENT_WIDTH),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isNarrow = constraints.maxWidth < 600;

                          return SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              child: Column(
                                children: [
                                  _buildAppBar(context, constraints),
                                  SizedBox(height: 20),
                                  _buildTimerSection(context, timerProvider, constraints),
                                  SizedBox(height: isNarrow ? 10 : 20),
                                  _buildControlsSection(context, timerProvider),
                                  SizedBox(height: isNarrow ? 10 : 20),
                                  _buildDurationControls(context, timerProvider),
                                  SizedBox(height: isNarrow ? 20 : 40),
                                  _buildTaskSection(context, taskProvider, constraints),
                                  SizedBox(height: 20),
                                  _buildColorPaletteSlider(context, themeProvider, constraints),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: pi / 2,
                  maxBlastForce: 5,
                  minBlastForce: 2,
                  emissionFrequency: 0.05,
                  numberOfParticles: 50,
                  gravity: 0.05,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, BoxConstraints constraints) {
    return Text(
      'Pomodoro Timer',
      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
            color: Colors.white,
            fontSize: constraints.maxWidth < 600 ? 24 : 32,
          ),
    );
  }

  Widget _buildTimerSection(BuildContext context, TimerProvider timerProvider, BoxConstraints constraints) {
    final timerSize = constraints.maxWidth < 600 ? constraints.maxWidth * 0.6 : 300.0;
    final fontSize = constraints.maxWidth < 600 ? 32.0 : 48.0;

    return Column(
      children: [
        Text(
          timerProvider.isWorkSession ? 'Focus Time' : 'Break Time',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: timerSize,
          height: timerSize,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: timerProvider.progress,
                strokeWidth: timerSize * 0.05,
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              Center(
                child: Text(
                  timerProvider.timeLeft,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        if (timerProvider.sessionCompleted)
          ElevatedButton(
            onPressed: () {
              timerProvider.startNextSession();
              timerProvider.startTimer(onEnd: () => _handleTimerEnd(context, timerProvider));
            },
            child: Text(
              timerProvider.isWorkSession ? 'Start Break' : 'Start Focus Time',
              style: TextStyle(fontSize: 18),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
      ],
    );
  }

  Widget _buildControlsSection(BuildContext context, TimerProvider timerProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildControlButton(
          context,
          icon: timerProvider.isRunning ? Icons.pause : Icons.play_arrow,
          onPressed: () {
            if (timerProvider.isRunning) {
              timerProvider.pauseTimer();
            } else {
              timerProvider.startTimer(onEnd: () => _handleTimerEnd(context, timerProvider));
            }
          },
        ),
        SizedBox(width: 20),
        _buildControlButton(
          context,
          icon: Icons.refresh,
          onPressed: () => timerProvider.resetTimer(),
        ),
      ],
    );
  }

  Widget _buildControlButton(BuildContext context, {required IconData icon, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Icon(icon, size: 32),
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(16),
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildDurationControls(BuildContext context, TimerProvider timerProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: _buildDurationControl(context, 'Work', timerProvider.workDuration ~/ 60, (value) => timerProvider.setWorkDuration(value), Icons.work)),
        SizedBox(width: 20),
        Expanded(child: _buildDurationControl(context, 'Break', timerProvider.breakDuration ~/ 60, (value) => timerProvider.setBreakDuration(value), Icons.coffee)),
      ],
    );
  }

  Widget _buildDurationControl(BuildContext context, String label, int duration, Function(int) onChanged, IconData icon) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                SizedBox(width: 4),
                Text(label, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.white, size: 20),
                  onPressed: () => onChanged(duration - 1 > 0 ? duration - 1 : 1),
                ),
                Text('$duration min', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white, size: 20),
                  onPressed: () => onChanged(duration + 1 <= 60 ? duration + 1 : 60),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskSection(BuildContext context, TaskProvider taskProvider, BoxConstraints constraints) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tasks',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white),
            ),
            SizedBox(height: 16),
            _buildTaskInput(context, taskProvider),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: _buildTaskList(context, taskProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskInput(BuildContext context, TaskProvider taskProvider) {
    return TextField(
      controller: _taskController,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Add a new task',
        hintStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            if (_taskController.text.isNotEmpty) {
              taskProvider.addTask(_taskController.text);
              _taskController.clear();
            }
          },
        ),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, TaskProvider taskProvider) {
    if (taskProvider.tasks.isEmpty) {
      return Center(
        child: Text(
          'No tasks yet. Add a task to get started!',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      itemCount: taskProvider.tasks.length,
      itemBuilder: (context, index) {
        final task = taskProvider.tasks[index];
        return Dismissible(
          key: Key(task.id),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            taskProvider.deleteTask(task.id);
          },
          child: ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                color: Colors.white,
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            leading: Checkbox(
              value: task.isCompleted,
              onChanged: (_) => taskProvider.toggleTaskCompletion(task.id),
              fillColor: MaterialStateProperty.resolveWith((states) => Colors.white.withOpacity(0.2)),
              checkColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      },
    );
  }

  Widget _buildColorPaletteSlider(BuildContext context, ThemeProvider themeProvider, BoxConstraints constraints) {
    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ThemeProvider.colorPalettes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => themeProvider.setColorPalette(index),
            child: Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: ThemeProvider.colorPalettes[index]['primary'],
                shape: BoxShape.circle,
                border: Border.all(
                  color: themeProvider.currentPaletteIndex == index
                      ? Colors.white
                      : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}