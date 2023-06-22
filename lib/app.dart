import 'package:flutter/material.dart';
import 'package:todo_app_firebase/common/constants/app_colors.dart';
import 'package:todo_app_firebase/core/router/app_router.dart';
import 'package:todo_app_firebase/gen/fonts.gen.dart';
import 'package:todo_app_firebase/l10n/l10n.dart';

final _appRouter = AppRouter();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
      theme: ThemeData(
        fontFamily: FontFamily.inter,
        textTheme: const TextTheme(
          displayMedium: TextStyle(
            color: AppColors.black,
            fontSize: 42,
            fontWeight: FontWeight.w700,
          ),
          displaySmall: TextStyle(
            color: AppColors.black,
            fontSize: 36,
            fontWeight: FontWeight.w700,
          ),
          headlineMedium: TextStyle(
            color: AppColors.black,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
          headlineSmall: TextStyle(
            color: AppColors.black,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
          titleLarge: TextStyle(
            color: AppColors.black,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
          titleSmall: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          bodySmall: TextStyle(
            color: AppColors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: TextStyle(
            color: AppColors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          labelLarge: TextStyle(
            color: AppColors.black,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
