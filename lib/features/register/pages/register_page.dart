import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_firebase/common/widgets/app_snack_bar.dart';
import 'package:todo_app_firebase/core/di/get_it.dart';
import 'package:todo_app_firebase/core/router/app_router.dart';
import 'package:todo_app_firebase/features/register/cubit/register_cubit.dart';
import 'package:todo_app_firebase/features/register/cubit/register_state.dart';
import 'package:todo_app_firebase/features/register/pages/register_page_body.dart';
import 'package:todo_app_firebase/features/register/repository/register_repository.dart';
import 'package:todo_app_firebase/utils/load_data_state.dart';

@RoutePage()
class RegisterPage extends StatelessWidget implements AutoRouteWrapper {
  const RegisterPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(
        registerRepository: sl<RegisterRepository>(),
      ),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
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
            predicate: (route) => route.isFirst,
          );
          return;
        }
      },
      builder: (context, state) {
        final cubit = context.read<RegisterCubit>();

        return RegisterPageBody(
          state: state,
          cubit: cubit,
        );
      },
    );
  }
}
