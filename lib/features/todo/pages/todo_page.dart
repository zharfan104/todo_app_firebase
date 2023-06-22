import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_firebase/core/di/get_it.dart';
import 'package:todo_app_firebase/features/logout/cubit/logout_cubit.dart';
import 'package:todo_app_firebase/features/logout/repository/logout_repository.dart';
import 'package:todo_app_firebase/features/todo/cubit/todo_cubit.dart';
import 'package:todo_app_firebase/features/todo/pages/todo_page_body.dart';
import 'package:todo_app_firebase/features/todo/repository/todo_repository.dart';

@RoutePage()
class TodoPage extends StatelessWidget implements AutoRouteWrapper {
  const TodoPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TodoCubit(
            todoRepository: sl<TodoRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => LogoutCubit(
            logoutRepository: sl<LogoutRepository>(),
          ),
        ),
      ],
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: TodoPageBody(),
    );
  }
}
