import 'package:injectable/injectable.dart';
import 'package:todo_app_firebase/common/models/todo_model.dart';
import 'package:todo_app_firebase/core/services/firebase_service.dart';

@singleton
class TodoRepository {
  TodoRepository({required this.firebaseService});

  final FirebaseService firebaseService;

  Future<List<TodoModel>> getTodos() async {
    return firebaseService.getTodos();
  }

  Future<void> addNewTodo(String title) {
    return firebaseService.addNewTodo(title);
  }

  Future<void> toggleTaskCompletion(String uid) {
    return firebaseService.toggleTaskCompletion(uid);
  }

  Future<void> removeTodo(String uid) {
    return firebaseService.removeTodo(uid);
  }
}
