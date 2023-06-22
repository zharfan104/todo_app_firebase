import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app_firebase/core/router/app_router.dart';
import 'package:todo_app_firebase/features/login/cubit/login_cubit.dart';
import 'package:todo_app_firebase/features/login/cubit/login_state.dart';
import 'package:todo_app_firebase/features/login/pages/login_page.dart';
import 'package:todo_app_firebase/features/login/pages/login_page_body.dart';
import 'package:todo_app_firebase/utils/load_data_state.dart';

import '../../../helpers/pump_app.dart';

class MockStackRouter extends Mock implements StackRouter {}

class FakePageRouteInfo extends Fake implements PageRouteInfo {}

class MockLoginCubit extends MockCubit<LoginState> implements LoginCubit {}

void main() {
  final LoginCubit mockLoginCubit = MockLoginCubit();
  final StackRouter mockRouter = MockStackRouter();

  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
  });

  setUp(() {
    when(mockLoginCubit.checkIfAlreadyLoggedIn).thenAnswer(
      (_) {},
    );
  });

  group('LoginPage', () {
    testWidgets('When login process successful, should navigate to TodoRoute',
        (tester) async {
      const loadedState = LoginState(
        email: '',
        password: '',
        isObscured: true,
        submitDataStatus: LoadedDataState(data: null),
      );

      when(() => mockLoginCubit.state).thenReturn(loadedState);
      whenListen(mockLoginCubit, Stream.fromIterable([loadedState]));
      when(
        () => mockRouter.pushAndPopUntil(
          any(),
          predicate: any(
            named: 'predicate',
          ),
        ),
      ).thenAnswer((_) async => null);

      await tester.pumpApp(
        StackRouterScope(
          controller: mockRouter,
          stateHash: 0,
          child: BlocProvider.value(
            value: mockLoginCubit,
            child: const LoginPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      verify(
        () => mockRouter.pushAndPopUntil(
          const TodoRoute(),
          predicate: any(named: 'predicate'),
        ),
      );
    });

    testWidgets(
        'should show the error message and handle login process got error',
        (tester) async {
      const errorState = LoginState(
        email: '',
        password: '',
        isObscured: true,
        submitDataStatus: ErrorDataState(errorMessage: 'Error Message'),
      );

      when(() => mockLoginCubit.state).thenReturn(errorState);
      whenListen(mockLoginCubit, Stream.fromIterable([errorState]));

      await tester.pumpApp(
        StackRouterScope(
          controller: mockRouter,
          stateHash: 0,
          child: BlocProvider.value(
            value: mockLoginCubit,
            child: const LoginPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Error Message'), findsOneWidget);
    });

    testWidgets('should show LoginPageBody', (tester) async {
      final initialState = LoginState(
        email: '',
        password: '',
        isObscured: true,
        submitDataStatus: InitialDataState<void>(),
      );

      when(() => mockLoginCubit.state).thenReturn(initialState);
      whenListen(mockLoginCubit, Stream.fromIterable([initialState]));

      await tester.pumpApp(
        StackRouterScope(
          controller: mockRouter,
          stateHash: 0,
          child: BlocProvider.value(
            value: mockLoginCubit,
            child: const LoginPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(LoginPageBody), findsOneWidget);
    });
  });
}
