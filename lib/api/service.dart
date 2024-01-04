import 'package:dio/dio.dart';
import '../models/task.dart';

class TaskService {




  static const String API_URL =  'http://localhost:8899/api/task';
  final Dio _dio = Dio();

  Future<List<Task>> getTasks() async {
    Response response = await _dio.get(API_URL);
    return (response.data as List).map((item) => Task.fromJson(item)).toList();
  }

  Future<Task> createTask(Task task) async {
    Response response = await _dio.post(
      API_URL,
      data: task.toJson(),
    );
    return Task.fromJson(response.data);
  }

  Future<Task> updateTask(Task task) async {
    Response response = await _dio.put(
      '$API_URL/${task.id}',
      data: task.toJson(),
    );
    return Task.fromJson(response.data);
  }

  Future<void> deleteTask(int id) async {
    await _dio.delete('$API_URL/$id');
  }
}
