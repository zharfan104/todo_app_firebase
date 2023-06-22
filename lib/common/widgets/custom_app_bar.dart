import 'package:flutter/material.dart';
import 'package:todo_app_firebase/common/constants/app_colors.dart';
import 'package:todo_app_firebase/common/widgets/app_bar_title.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    required this.title,
    this.actions = const [],
    super.key,
  });

  final String title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: AppBarTitle(title: title),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
