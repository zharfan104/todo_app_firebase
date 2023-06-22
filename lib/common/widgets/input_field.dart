import 'package:flutter/material.dart';
import 'package:todo_app_firebase/common/constants/app_colors.dart';
import 'package:todo_app_firebase/common/constants/app_size.dart';

const _kInputTextHeight = 58.0;

class InputField extends StatelessWidget {
  const InputField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
    super.key,
    this.isObscured = false,
    this.toggleObscured,
  });

  final String label;
  final String initialValue;
  final bool isObscured;
  final void Function(String) onChanged;
  final VoidCallback? toggleObscured;

  bool get isHaveObscured => toggleObscured != null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isHaveObscured ? 110 : 95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: kSpacingSmall),
          Container(
            height: _kInputTextHeight,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(kSpacingXSmall),
            ),
            child: TextFormField(
              keyboardType: isObscured
                  ? TextInputType.visiblePassword
                  : TextInputType.text,
              onChanged: onChanged,
              initialValue: initialValue,
              obscureText: isObscured,
              style: Theme.of(context).textTheme.titleLarge,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                filled: true,
                fillColor: AppColors.skyBlue.withOpacity(0),
                isDense: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(kSpacingSmall),
                ),
                suffixIcon: isHaveObscured
                    ? GestureDetector(
                        onTap: toggleObscured,
                        child: Icon(
                          isObscured ? Icons.visibility_off : Icons.visibility,
                          size: kSpacingXMedium,
                          color: AppColors.darkBlue,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
