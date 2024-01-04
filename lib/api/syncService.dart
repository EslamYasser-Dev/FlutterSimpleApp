import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:todo/api/service.dart';
import '../db/db_helper.dart';
import '../models/task.dart';

class SyncService {
  final TaskService _taskService = TaskService();
   final DBHelper _dbHelper = DBHelper();
  final Connectivity _connectivity = Connectivity();

  SyncService() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        _syncTasks();
        _postTasks();
      }
    });
  }

  Future<void> _syncTasks() async {
    // Fetch tasks from the API
    List<Task> tasks = await _taskService.getTasks();

    // Insert each task into local database
    for (Task task in tasks) {
      await DBHelper.insert(task);
    }
  }

  Future<void> _postTasks() async {
    // Query all tasks from the database
    List<Map<String, dynamic>> tasks = await DBHelper.query();

    // Post each task to the API
    for (Map<String, dynamic> task in tasks) {
      await _taskService.createTask(Task.fromJson(task));
    }
  }
}
