import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app_firebase/common/widgets/custom_button.dart';
import 'package:todo_app_firebase/common/widgets/input_field.dart';
import 'package:todo_app_firebase/features/login/cubit/login_cubit.dart';
import 'package:todo_app_firebase/features/login/cubit/login_state.dart';
import 'package:todo_app_firebase/features/login/pages/login_page_body.dart';
import 'package:todo_app_firebase/utils/load_data_state.dart';

import '../../../helpers/helpers.dart';

class MockLoginCubit extends MockCubit<LoginState> implements LoginCubit {}

void main() {
  final mockLoginCubit = MockLoginCubit();

  final initialState = LoginState(
    email: '',
    password: '',
    isObscured: true,
    submitDataStatus: InitialDataState(),
  );

  final loadingState = LoginState(
    email: '',
    password: '',
    isObscured: true,
    submitDataStatus: LoadingDataState(),
  );

  setUp(() {
    when(() => mockLoginCubit.state).thenReturn(initialState);
    when(mockLoginCubit.checkIfAlreadyLoggedIn).thenAnswer(
      (_) {},
    );
  });

  group('LoginPageBody', () {
    testWidgets('should call checkIfAlreadyLoggedIn in initState',
        (tester) async {
      await tester.pumpApp(
        BlocProvider<LoginCubit>.value(
          value: mockLoginCubit,
          child: LoginPageBody(
            state: initialState,
            cubit: mockLoginCubit,
          ),
        ),
      );

      verify(mockLoginCubit.checkIfAlreadyLoggedIn);
    });

    testWidgets('shows correct titles', (tester) async {
      await tester.pumpApp(
        BlocProvider<LoginCubit>.value(
          value: mockLoginCubit,
          child: LoginPageBody(
            state: initialState,
            cubit: mockLoginCubit,
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('You do not have an account'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Login'), findsNWidgets(2));
    });

    testWidgets('shows loading when LoginState is loading', (tester) async {
      when(() => mockLoginCubit.state).thenReturn(loadingState);

      await tester.pumpApp(
        BlocProvider<LoginCubit>.value(
          value: mockLoginCubit,
          child: LoginPageBody(
            state: loadingState,
            cubit: mockLoginCubit,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  testWidgets('filling email and password fields triggers cubit',
      (tester) async {
    await tester.pumpApp(
      BlocProvider<LoginCubit>.value(
        value: mockLoginCubit,
        child: LoginPageBody(
          state: initialState,
          cubit: mockLoginCubit,
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

    verify(() => mockLoginCubit.setEmail('test@example.com'));
    verify(() => mockLoginCubit.setPassword('password123'));
  });

  testWidgets('tapping login button triggers cubit', (tester) async {
    when(mockLoginCubit.logIn).thenAnswer(
      (_) => Future.value(),
    );

    await tester.pumpApp(
      BlocProvider<LoginCubit>.value(
        value: mockLoginCubit,
        child: LoginPageBody(
          state: initialState,
          cubit: mockLoginCubit,
        ),
      ),
    );

    final loginButton = find.byWidgetPredicate(
      (widget) => widget is CustomButton && widget.text == 'Login',
    );

    await tester.tap(loginButton);

    verify(mockLoginCubit.logIn);

    await tester.pump();
  });
}
