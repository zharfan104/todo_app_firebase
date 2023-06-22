import 'package:flutter/material.dart';
import 'package:todo_app_firebase/common/constants/app_size.dart';
import 'package:todo_app_firebase/common/models/todo_model.dart';
import 'package:todo_app_firebase/features/todo/cubit/todo_cubit.dart';
import 'package:todo_app_firebase/features/todo/widgets/todo_item.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({
    required this.todos,
    required this.todoCubit,
    super.key,
  });

  final List<TodoModel> todos;
  final TodoCubit todoCubit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.height,
      child: ListView.separated(
        separatorBuilder: (context, index) =>
            const SizedBox(height: kSpacingSmall),
        itemCount: todos.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => TodoItem(
          todo: todos[index],
          todoCubit: todoCubit,
        ),
      ),
    );
  }
}
