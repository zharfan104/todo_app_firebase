import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_firebase/common/constants/app_colors.dart';

class ActionPrompt extends StatelessWidget {
  const ActionPrompt({
    required this.promptText,
    required this.actionText,
    required this.targetRoute,
    super.key,
  });

  final String promptText;
  final String actionText;
  final PageRouteInfo targetRoute;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          promptText,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        TextButton(
          onPressed: () async {
            await context.router.push(targetRoute);
          },
          child: Text(
            actionText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.rainBlueLight,
                ),
          ),
        ),
      ],
    );
  }
}
