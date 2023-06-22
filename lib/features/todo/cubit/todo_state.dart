import 'package:equatable/equatable.dart';
import 'package:todo_app_firebase/common/models/todo_model.dart';

import 'package:todo_app_firebase/utils/load_data_state.dart';

class TodoState extends Equatable {
  const TodoState({
    required this.newTodoTitle,
    required this.todoListStatus,
  });

  final String newTodoTitle;
  final LoadDataState<List<TodoModel>> todoListStatus;

  TodoState copyWith({
    String? newTodoTitle,
    LoadDataState<List<TodoModel>>? todoListStatus,
  }) {
    return TodoState(
      newTodoTitle: newTodoTitle ?? this.newTodoTitle,
      todoListStatus: todoListStatus ?? this.todoListStatus,
    );
  }

  @override
  List<Object?> get props => [newTodoTitle, todoListStatus];
}
