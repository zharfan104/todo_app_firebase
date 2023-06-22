import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todo_app_firebase/common/constants/app_colors.dart';
import 'package:todo_app_firebase/common/constants/app_size.dart';
import 'package:todo_app_firebase/common/models/todo_model.dart';
import 'package:todo_app_firebase/features/todo/cubit/todo_cubit.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    required this.todo,
    required this.todoCubit,
    super.key,
  });

  final TodoModel todo;
  final TodoCubit todoCubit;

  @override
  Widget build(BuildContext context) {
    final containerColor =
        todo.isCompleted ? AppColors.darkBlue : AppColors.pinkRed;

    return Dismissible(
      key: Key(todo.title),
      background: Container(
        padding: const EdgeInsets.only(left: kSpacingMedium),
        alignment: Alignment.centerLeft,
        color: AppColors.pinkRed,
        child: const Icon(Icons.delete),
      ),
      onDismissed: (_) {
        todoCubit.removeTodo(todo.uid);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: kSpacingSmall),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(kSpacingXSmall),
        ),
        child: ListTile(
          onTap: () {
            todoCubit.toggleTaskCompletion(todo.uid);
          },
          leading: Container(
            padding: const EdgeInsets.all(kSpacingXXSmall),
            height: kSpacingXMedium,
            width: kSpacingXMedium,
            decoration: BoxDecoration(
              color: todo.isCompleted ? null : AppColors.white,
              shape: BoxShape.circle,
            ),
            child: todo.isCompleted
                ? const Icon(
                    Iconsax.tick_circle,
                    color: AppColors.white,
                  )
                : const SizedBox(),
          ),
          title: Text(
            todo.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.white,
                ),
          ),
        ),
      ),
    );
  }
}
