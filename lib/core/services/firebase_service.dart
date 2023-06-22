import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app_firebase/common/models/todo_model.dart';

@singleton
class FirebaseService {
  FirebaseService({
    required this.firebaseAuth,
    required this.firestore,
  });

  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  String? get userId => firebaseAuth.currentUser?.uid;

  CollectionReference get todosCollection =>
      firestore.collection('users').doc(userId).collection('Todos');

  Future<void> addNewTodo(String title) async {
    await todosCollection.add({
      'title': title,
      'isCompleted': false,
    });
  }

  Future<void> toggleTaskCompletion(String uid) async {
    final docSnapshot = await todosCollection.doc(uid).get();
    final currentStatus = docSnapshot['isCompleted'] as bool;
    await todosCollection.doc(uid).update({'isCompleted': !currentStatus});
  }

  Future<void> removeTodo(String uid) async {
    await todosCollection.doc(uid).delete();
  }

  Future<List<TodoModel>> getTodos() async {
    final snapshot = await todosCollection.get();

    final todos = snapshot.docs.map((e) {
      return TodoModel(
        isCompleted: e['isCompleted'] as bool,
        title: e['title'] as String,
        uid: e.id,
      );
    }).toList();

    return todos;
  }
}
