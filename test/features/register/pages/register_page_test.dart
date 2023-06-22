import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app_firebase/core/router/app_router.dart';
import 'package:todo_app_firebase/features/register/cubit/register_cubit.dart';
import 'package:todo_app_firebase/features/register/cubit/register_state.dart';
import 'package:todo_app_firebase/features/register/pages/register_page.dart';
import 'package:todo_app_firebase/features/register/pages/register_page_body.dart';
import 'package:todo_app_firebase/utils/load_data_state.dart';

import '../../../helpers/helpers.dart';

class MockStackRouter extends Mock implements StackRouter {}

class FakePageRouteInfo extends Fake implements PageRouteInfo {}

class MockRegisterCubit extends MockCubit<RegisterState>
    implements RegisterCubit {}

void main() {
  final RegisterCubit mockRegisterCubit = MockRegisterCubit();
  final StackRouter mockRouter = MockStackRouter();

  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
  });

  group('RegisterPage', () {
    testWidgets(
        'When registration process successful, should navigate to TodoRoute',
        (tester) async {
      const loadedState = RegisterState(
        email: '',
        password: '',
        isObscured: true,
        submitDataStatus: LoadedDataState(data: null),
      );

      when(() => mockRegisterCubit.state).thenReturn(loadedState);
      whenListen(mockRegisterCubit, Stream.fromIterable([loadedState]));
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
            value: mockRegisterCubit,
            child: const RegisterPage(),
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
        'should show the error message and handle registration process got error',
        (tester) async {
      const errorState = RegisterState(
        email: '',
        password: '',
        isObscured: true,
        submitDataStatus: ErrorDataState(errorMessage: 'Error Message'),
      );

      when(() => mockRegisterCubit.state).thenReturn(errorState);
      whenListen(mockRegisterCubit, Stream.fromIterable([errorState]));

      await tester.pumpApp(
        StackRouterScope(
          controller: mockRouter,
          stateHash: 0,
          child: BlocProvider.value(
            value: mockRegisterCubit,
            child: const RegisterPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Error Message'), findsOneWidget);
    });

    testWidgets('should show RegisterPageBody', (tester) async {
      final initialState = RegisterState(
        email: '',
        password: '',
        isObscured: true,
        submitDataStatus: InitialDataState<void>(),
      );

      when(() => mockRegisterCubit.state).thenReturn(initialState);
      whenListen(mockRegisterCubit, Stream.fromIterable([initialState]));

      await tester.pumpApp(
        StackRouterScope(
          controller: mockRouter,
          stateHash: 0,
          child: BlocProvider.value(
            value: mockRegisterCubit,
            child: const RegisterPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(RegisterPageBody), findsOneWidget);
    });
  });
}
