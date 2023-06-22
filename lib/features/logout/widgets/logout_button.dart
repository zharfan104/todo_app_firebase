import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todo_app_firebase/common/constants/app_colors.dart';
import 'package:todo_app_firebase/common/widgets/app_snack_bar.dart';
import 'package:todo_app_firebase/core/router/app_router.dart';
import 'package:todo_app_firebase/features/logout/cubit/logout_cubit.dart';
import 'package:todo_app_firebase/utils/load_data_state.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    required this.logoutCubit,
    super.key,
  });

  final LogoutCubit logoutCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: logoutCubit,
      child: BlocConsumer<LogoutCubit, LoadDataState<void>>(
        listener: (context, state) async {
          if (state.isError) {
            AppSnackBar.show(
              context,
              text: state.getErrorMessage!,
            );
            return;
          }
          if (state.isLoaded) {
            await context.router.pushAndPopUntil(
              const LoginRoute(),
              predicate: (route) => route.isFirst,
            );

            return;
          }
        },
        builder: (context, state) {
          return IconButton(
            onPressed: () {
              context.read<LogoutCubit>().logout();
            },
            icon: Icon(
              state.isLoading ? Iconsax.timer : Iconsax.logout,
              color: AppColors.black,
            ),
          );
        },
      ),
    );
  }
}
