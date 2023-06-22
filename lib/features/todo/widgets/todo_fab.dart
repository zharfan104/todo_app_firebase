import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_firebase/common/constants/app_colors.dart';
import 'package:todo_app_firebase/common/constants/app_size.dart'; // import app_size.dart
import 'package:todo_app_firebase/features/todo/cubit/todo_cubit.dart';
import 'package:todo_app_firebase/gen/assets.gen.dart';
import 'package:todo_app_firebase/l10n/l10n.dart';

const _kBottomSheetHeight = 300.0;

class TodoFab extends StatelessWidget {
  const TodoFab({
    required this.todoCubit,
    super.key,
  });

  final TodoCubit todoCubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kSpacingXLarge,
      width: kSpacingXLarge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kSpacingXSmall),
        color: AppColors.pinkRed,
      ),
      child: FloatingActionButton(
        onPressed: () {
          _addNewTodoBottomSheet(
            context,
            onSubmitCallback: todoCubit.addNewTodo,
          );
        },
        backgroundColor: AppColors.transparent,
        elevation: 0,
        child: Assets.icons.document.svg(
          height: kSpacingXMedium,
          width: kSpacingXMedium,
        ),
      ),
    );
  }

  void _addNewTodoBottomSheet(
    BuildContext context, {
    required ValueChanged<String> onSubmitCallback,
  }) {
    final todoController = TextEditingController();

    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kSpacingSmall),
          topRight: Radius.circular(kSpacingSmall),
        ),
      ),
      backgroundColor: AppColors.lightGray,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: _kBottomSheetHeight,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: kSpacingXMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(
                        top: kSpacingXMedium,
                        left: kSpacingSmall,
                      ),
                      child: Text(
                        context.l10n.addTodo,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: kSpacingLarge),
                    Container(
                      height: kSpacingLarge + kSpacingMedium,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(kSpacingSmall),
                      ),
                      child: TextField(
                        controller: todoController,
                        style: Theme.of(context).textTheme.titleLarge,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          filled: true,
                          fillColor: AppColors.skyBlue.withOpacity(0),
                          isDense: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(kSpacingMedium),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: kSpacingMedium),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: AppColors.pinkRed,
                        borderRadius: BorderRadius.circular(kSpacingSmall),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.transparent,
                          elevation: 0,
                        ),
                        onPressed: () async {
                          onSubmitCallback(todoController.text);

                          await context.router.pop();

                          todoController.clear();
                        },
                        child: Text(
                          context.l10n.addTodo,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
