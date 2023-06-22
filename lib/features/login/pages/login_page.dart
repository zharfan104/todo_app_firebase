import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_firebase/common/widgets/app_snack_bar.dart';
import 'package:todo_app_firebase/core/di/get_it.dart';
import 'package:todo_app_firebase/core/router/app_router.dart';
import 'package:todo_app_firebase/features/login/cubit/login_cubit.dart';
import 'package:todo_app_firebase/features/login/cubit/login_state.dart';
import 'package:todo_app_firebase/features/login/pages/login_page_body.dart';
import 'package:todo_app_firebase/features/login/repository/login_repository.dart';
import 'package:todo_app_firebase/utils/load_data_state.dart';

@RoutePage()
class LoginPage extends StatelessWidget implements AutoRouteWrapper {
  const LoginPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        loginRepository: sl<LoginRepository>(),
      ),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) async {
        if (state.submitDataStatus.isError) {
          AppSnackBar.show(
            context,
            text: state.submitDataStatus.getErrorMessage!,
          );

          return;
        }
        if (state.submitDataStatus.isLoaded) {
          await context.router.pushAndPopUntil(
            const TodoRoute(),
            predicate: (route) => false,
          );

          return;
        }
      },
      builder: (context, state) {
        final cubit = context.read<LoginCubit>();

        return LoginPageBody(
          state: state,
          cubit: cubit,
        );
      },
    );
  }
}
