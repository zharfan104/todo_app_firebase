import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_firebase/common/constants/app_colors.dart';
import 'package:todo_app_firebase/common/widgets/center_text.dart';
import 'package:todo_app_firebase/common/widgets/custom_app_bar.dart';
import 'package:todo_app_firebase/features/logout/cubit/logout_cubit.dart';
import 'package:todo_app_firebase/features/logout/widgets/logout_button.dart';
import 'package:todo_app_firebase/features/todo/cubit/todo_cubit.dart';
import 'package:todo_app_firebase/features/todo/cubit/todo_state.dart';
import 'package:todo_app_firebase/features/todo/widgets/todo_fab.dart';
import 'package:todo_app_firebase/features/todo/widgets/todo_list_view.dart';
import 'package:todo_app_firebase/l10n/l10n.dart';
import 'package:todo_app_firebase/utils/load_data_state.dart';

class TodoPageBody extends StatefulWidget {
  const TodoPageBody({super.key});

  @override
  State<TodoPageBody> createState() => _TodoPageBodyState();
}

class _TodoPageBodyState extends State<TodoPageBody> {
  @override
  void initState() {
    super.initState();
    context.read<TodoCubit>().getTodos(isInitialLoadingShown: true);
  }

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();

    return Scaffold(
      appBar: CustomAppBar(
        title: context.l10n.todoTitle,
        actions: [
          LogoutButton(
            logoutCubit: context.read<LogoutCubit>(),
          ),
        ],
      ),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          if (state.todoListStatus.isError) {
            return CenterText(
              text: state.todoListStatus.getErrorMessage!,
            );
          }

          if (state.todoListStatus.isLoading) {
            return const CircularProgressIndicator(
              color: AppColors.white,
            );
          }

          final todos = state.todoListStatus.getData ?? [];
          if (todos.isEmpty) {
            return CenterText(
              text: context.l10n.emptyToDo,
            );
          }

          return TodoListView(
            todos: todos,
            todoCubit: todoCubit,
          );
        },
      ),
      floatingActionButton: TodoFab(
        todoCubit: todoCubit,
      ),
    );
  }
}
