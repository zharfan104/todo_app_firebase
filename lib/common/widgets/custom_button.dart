import 'package:flutter/material.dart';
import 'package:todo_app_firebase/common/constants/app_colors.dart';

const _kCustomButtonHeight = 55.0;

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    required this.onPressed,
    required this.isLoading,
    super.key,
    this.color = AppColors.darkBlue,
  });

  final String text;
  final bool isLoading;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kCustomButtonHeight,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.transparent,
          elevation: 0,
        ),
        onPressed: onPressed,
        child: isLoading
            ? const CircularProgressIndicator(
                color: AppColors.white,
              )
            : Text(
                text,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                    ),
              ),
      ),
    );
  }
}
