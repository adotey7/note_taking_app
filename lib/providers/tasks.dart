import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task.dart';

class Tasks with ChangeNotifier {
  Tasks() {
    init();
  }
  Isar? isar;
  final _tasks = <Task>[];

  List<Task> get tasks => [..._tasks];

  void init() async {
    final dir = await getApplicationSupportDirectory();
    isar = await Isar.open(
      [TaskSchema],
      directory: dir.path,
    );

    final taskCollection = await isar!.tasks.where().findAll();
    _tasks.addAll(taskCollection);
    notifyListeners();
  }

  Task findById(int id) {
    return _tasks.firstWhere((item) => item.id == id);
  }

  Task findByTitle(String title) {
    return _tasks
        .firstWhere((element) => element.title!.toLowerCase() == title);
  }

  void addTask(Task newTask) async {
    await isar!.writeTxn(() async {
      await isar!.tasks.put(newTask);
    });
    _tasks.add(newTask);
    notifyListeners();
  }

  void updateTask(int id, Task newTask) async {
    // locally get index
    final index = _tasks.indexWhere((element) => element.id == id);

    await isar!.writeTxn(() async {
     
      await isar!.tasks.put(newTask);
    });
    _tasks[index] = newTask;
    notifyListeners();
  }

  void deleteTask(int id, Task task) async {
    var deleted = false;
    await isar!.writeTxn(() async {
      await isar!.tasks.delete(task.id);
      deleted = true;
    });
    if (deleted) {
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
    }
  }
}
