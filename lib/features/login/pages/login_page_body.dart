import 'package:flutter/material.dart';
import 'package:todo_app_firebase/common/constants/app_size.dart';
import 'package:todo_app_firebase/common/widgets/account_prompt.dart';
import 'package:todo_app_firebase/common/widgets/custom_app_bar.dart';
import 'package:todo_app_firebase/common/widgets/custom_button.dart';
import 'package:todo_app_firebase/common/widgets/input_field.dart';
import 'package:todo_app_firebase/core/router/app_router.dart';
import 'package:todo_app_firebase/features/login/cubit/login_cubit.dart';
import 'package:todo_app_firebase/features/login/cubit/login_state.dart';
import 'package:todo_app_firebase/l10n/l10n.dart';
import 'package:todo_app_firebase/utils/load_data_state.dart';

class LoginPageBody extends StatefulWidget {
  const LoginPageBody({
    required this.state,
    required this.cubit,
    super.key,
  });

  final LoginState state;
  final LoginCubit cubit;

  @override
  State<LoginPageBody> createState() => _LoginPageBodyState();
}

class _LoginPageBodyState extends State<LoginPageBody> {
  LoginCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.checkIfAlreadyLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: context.l10n.loginTitle,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(kSpacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: kSpacingLarge),
                InputField(
                  label: context.l10n.emailTitle,
                  initialValue: widget.state.email,
                  onChanged: cubit.setEmail,
                ),
                const SizedBox(height: kSpacingMedium),
                InputField(
                  label: context.l10n.passwordTitle,
                  initialValue: widget.state.password,
                  isObscured: widget.state.isObscured,
                  onChanged: cubit.setPassword,
                  toggleObscured: cubit.toggleObscured,
                ),
                const SizedBox(height: kSpacingMedium),
                ActionPrompt(
                  promptText: context.l10n.noAccountPrompt,
                  actionText: context.l10n.createAccountPrompt,
                  targetRoute: const RegisterRoute(),
                ),
                const SizedBox(height: kSpacingMedium),
                CustomButton(
                  text: context.l10n.loginTitle,
                  onPressed: cubit.logIn,
                  isLoading: widget.state.submitDataStatus.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
