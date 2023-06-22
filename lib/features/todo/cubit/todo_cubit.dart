import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_firebase/common/models/todo_model.dart';
import 'package:todo_app_firebase/features/todo/cubit/todo_state.dart';
import 'package:todo_app_firebase/features/todo/repository/todo_repository.dart';
import 'package:todo_app_firebase/utils/load_data_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit({required this.todoRepository})
      : super(
          TodoState(
            newTodoTitle: '',
            todoListStatus: InitialDataState<List<TodoModel>>(),
          ),
        );

  final TodoRepository todoRepository;

  Future<void> getTodos({bool isInitialLoadingShown = false}) async {
    if (isInitialLoadingShown) {
      emit(state.copyWith(todoListStatus: LoadingDataState<List<TodoModel>>()));
    }
    try {
      final todos = await todoRepository.getTodos();
      emit(
        state.copyWith(
          todoListStatus: LoadedDataState<List<TodoModel>>(data: todos),
        ),
      );
    } on FirebaseException catch (e) {
      emit(
        state.copyWith(
          todoListStatus:
              ErrorDataState<List<TodoModel>>(errorMessage: e.toString()),
        ),
      );
    }
  }

  Future<void> addNewTodo(String title) async {
    try {
      await todoRepository.addNewTodo(title);
      await getTodos();
    } on FirebaseException catch (e) {
      emit(
        state.copyWith(
          todoListStatus:
              ErrorDataState<List<TodoModel>>(errorMessage: e.toString()),
        ),
      );
    }
  }

  Future<void> toggleTaskCompletion(String uid) async {
    try {
      // Update the state immediately.
      final todos = state.todoListStatus.getData ?? const [];
      final selectedTodo = todos.firstWhere((todo) => todo.uid == uid);
      final updatedTodo =
          selectedTodo.copyWith(isCompleted: !selectedTodo.isCompleted);

      final updatedTodos =
          todos.map((todo) => todo.uid == uid ? updatedTodo : todo).toList();

      emit(
        state.copyWith(
          todoListStatus: LoadedDataState<List<TodoModel>>(data: updatedTodos),
        ),
      );

      // Then call the repository to update the data in the backend.
      await todoRepository.toggleTaskCompletion(uid);
      await getTodos();
    } on FirebaseException catch (e) {
      emit(
        state.copyWith(
          todoListStatus:
              ErrorDataState<List<TodoModel>>(errorMessage: e.toString()),
        ),
      );
    }
  }

  Future<void> removeTodo(String uid) async {
    try {
      await todoRepository.removeTodo(uid);
      await getTodos();
    } on FirebaseException catch (e) {
      emit(
        state.copyWith(
          todoListStatus:
              ErrorDataState<List<TodoModel>>(errorMessage: e.toString()),
        ),
      );
    }
  }
}
