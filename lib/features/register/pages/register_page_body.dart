import 'package:flutter/material.dart';
import 'package:todo_app_firebase/common/constants/app_size.dart';
import 'package:todo_app_firebase/common/widgets/account_prompt.dart';
import 'package:todo_app_firebase/common/widgets/custom_app_bar.dart';
import 'package:todo_app_firebase/common/widgets/custom_button.dart';
import 'package:todo_app_firebase/common/widgets/input_field.dart';
import 'package:todo_app_firebase/core/router/app_router.dart';
import 'package:todo_app_firebase/features/register/cubit/register_cubit.dart';
import 'package:todo_app_firebase/features/register/cubit/register_state.dart';
import 'package:todo_app_firebase/l10n/l10n.dart';
import 'package:todo_app_firebase/utils/load_data_state.dart';

class RegisterPageBody extends StatefulWidget {
  const RegisterPageBody({
    required this.state,
    required this.cubit,
    super.key,
  });

  final RegisterState state;
  final RegisterCubit cubit;

  @override
  State<RegisterPageBody> createState() => _RegisterPageBodyState();
}

class _RegisterPageBodyState extends State<RegisterPageBody> {
  RegisterCubit get cubit => widget.cubit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: context.l10n.createAccountPrompt,
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
                  promptText: context.l10n.existingAccountPrompt,
                  actionText: context.l10n.loginTitle,
                  targetRoute: const LoginRoute(),
                ),
                const SizedBox(height: kSpacingMedium),
                CustomButton(
                  text: context.l10n.createAccountPrompt,
                  onPressed: cubit.register,
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
