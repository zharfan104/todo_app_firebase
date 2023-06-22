import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app_firebase/common/widgets/custom_button.dart';
import 'package:todo_app_firebase/common/widgets/input_field.dart';
import 'package:todo_app_firebase/features/register/cubit/register_cubit.dart';
import 'package:todo_app_firebase/features/register/cubit/register_state.dart';
import 'package:todo_app_firebase/features/register/pages/register_page_body.dart';
import 'package:todo_app_firebase/utils/load_data_state.dart';

import '../../../helpers/helpers.dart';

class MockRegisterCubit extends MockCubit<RegisterState>
    implements RegisterCubit {}

void main() {
  final mockRegisterCubit = MockRegisterCubit();

  final registerInitialState = RegisterState(
    email: '',
    password: '',
    isObscured: true,
    submitDataStatus: InitialDataState(),
  );

  final registerLoadingState = RegisterState(
    email: '',
    password: '',
    isObscured: true,
    submitDataStatus: LoadingDataState(),
  );

  setUp(() {
    when(() => mockRegisterCubit.state).thenReturn(registerInitialState);
  });

  group('RegisterPageBody', () {
    testWidgets('shows correct titles', (tester) async {
      await tester.pumpApp(
        BlocProvider<RegisterCubit>.value(
          value: mockRegisterCubit,
          child: RegisterPageBody(
            state: registerInitialState,
            cubit: mockRegisterCubit,
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Already have an account?'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Create Account'), findsNWidgets(2));
    });

    testWidgets('shows loading when RegisterState is loading', (tester) async {
      when(() => mockRegisterCubit.state).thenReturn(registerLoadingState);

      await tester.pumpApp(
        BlocProvider<RegisterCubit>.value(
          value: mockRegisterCubit,
          child: RegisterPageBody(
            state: registerLoadingState,
            cubit: mockRegisterCubit,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('filling email and password fields triggers cubit',
        (tester) async {
      await tester.pumpApp(
        BlocProvider<RegisterCubit>.value(
          value: mockRegisterCubit,
          child: RegisterPageBody(
            state: registerInitialState,
            cubit: mockRegisterCubit,
          ),
        ),
      );

      final emailField = find.byWidgetPredicate(
        (widget) => widget is InputField && widget.label == 'Email',
      );
      final passwordField = find.byWidgetPredicate(
        (widget) => widget is InputField && widget.label == 'Password',
      );

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');

      verify(() => mockRegisterCubit.setEmail('test@example.com'));
      verify(() => mockRegisterCubit.setPassword('password123'));
    });

    testWidgets('tapping create account button triggers cubit', (tester) async {
      when(mockRegisterCubit.register).thenAnswer(
        (_) => Future.value(),
      );

      await tester.pumpApp(
        BlocProvider<RegisterCubit>.value(
          value: mockRegisterCubit,
          child: RegisterPageBody(
            state: registerInitialState,
            cubit: mockRegisterCubit,
          ),
        ),
      );

      final registerButton = find.byWidgetPredicate(
        (widget) => widget is CustomButton && widget.text == 'Create Account',
      );

      await tester.tap(registerButton);

      verify(mockRegisterCubit.register);

      await tester.pump();
    });
  });
}
