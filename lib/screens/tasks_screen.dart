import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro/providers/task_provider.dart';

class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return ListView.builder(
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, index) {
              final task = taskProvider.tasks[index];
              return ListTile(
                title: Text(task.title),
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (_) => taskProvider.toggleTaskCompletion(task.id),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => taskProvider.deleteTask(task.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showAddTaskDialog(context),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    String newTaskTitle = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Task'),
        content: TextField(
          autofocus: true,
          onChanged: (value) => newTaskTitle = value,
          decoration: InputDecoration(hintText: 'Enter task title'),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Add'),
            onPressed: () {
              if (newTaskTitle.isNotEmpty) {
                taskProvider.addTask(newTaskTitle);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}