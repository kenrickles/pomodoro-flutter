import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Task {
  String id;
  String title;
  bool isCompleted;

  Task({required this.id, required this.title, this.isCompleted = false});

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isCompleted': isCompleted,
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    isCompleted: json['isCompleted'],
  );
}

class TaskProvider with ChangeNotifier {
  final SharedPreferences prefs;
  List<Task> _tasks = [];

  TaskProvider(this.prefs) {
    _loadTasks();
  }

  List<Task> get tasks => _tasks;

  void _loadTasks() {
    final tasksJson = prefs.getStringList('tasks') ?? [];
    _tasks = tasksJson.map((taskJson) => Task.fromJson(json.decode(taskJson))).toList();
    notifyListeners();
  }

  void _saveTasks() {
    final tasksJson = _tasks.map((task) => json.encode(task.toJson())).toList();
    prefs.setStringList('tasks', tasksJson);
  }

  void addTask(String title) {
    final newTask = Task(id: DateTime.now().toString(), title: title);
    _tasks.add(newTask);
    _saveTasks();
    notifyListeners();
  }

  void toggleTaskCompletion(String id) {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      _tasks[taskIndex].isCompleted = !_tasks[taskIndex].isCompleted;
      _saveTasks();
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveTasks();
    notifyListeners();
  }
}