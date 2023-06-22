import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app_firebase/core/router/app_router.dart';
import 'package:todo_app_firebase/features/logout/cubit/logout_cubit.dart';
import 'package:todo_app_firebase/features/logout/widgets/logout_button.dart';
import 'package:todo_app_firebase/utils/load_data_state.dart';

import '../../../helpers/helpers.dart';

class MockStackRouter extends Mock implements StackRouter {}

class FakePageRouteInfo extends Fake implements PageRouteInfo {}

class MockLogoutCubit extends MockCubit<LoadDataState<void>>
    implements LogoutCubit {}

void main() {
  final LogoutCubit mockLogoutCubit = MockLogoutCubit();
  final StackRouter mockRouter = MockStackRouter();

  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
  });

  group('LogoutButton', () {
    testWidgets('When logout process successful, should navigate to LoginRoute',
        (tester) async {
      const loadedState = LoadedDataState<void>(data: null);

      when(() => mockLogoutCubit.state).thenReturn(loadedState);
      whenListen(mockLogoutCubit, Stream.fromIterable([loadedState]));
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
            value: mockLogoutCubit,
            child: Scaffold(body: LogoutButton(logoutCubit: mockLogoutCubit)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      verify(
        () => mockRouter.pushAndPopUntil(
          const LoginRoute(),
          predicate: any(named: 'predicate'),
        ),
      );
    });

    testWidgets(
        'should show the error message and handle logout process got error',
        (tester) async {
      const errorState = ErrorDataState<void>(errorMessage: 'Error Message');

      when(() => mockLogoutCubit.state).thenReturn(errorState);
      whenListen(mockLogoutCubit, Stream.fromIterable([errorState]));

      await tester.pumpApp(
        StackRouterScope(
          controller: mockRouter,
          stateHash: 0,
          child: BlocProvider.value(
            value: mockLogoutCubit,
            child: Scaffold(body: LogoutButton(logoutCubit: mockLogoutCubit)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Error Message'), findsOneWidget);
    });

    testWidgets('should show IconButton and invoke logout', (tester) async {
      final initialState = InitialDataState<void>();

      when(mockLogoutCubit.logout).thenAnswer((_) => Future.value());

      when(() => mockLogoutCubit.state).thenReturn(initialState);
      whenListen(mockLogoutCubit, Stream.fromIterable([initialState]));

      await tester.pumpApp(
        StackRouterScope(
          controller: mockRouter,
          stateHash: 0,
          child: BlocProvider.value(
            value: mockLogoutCubit,
            child: Scaffold(body: LogoutButton(logoutCubit: mockLogoutCubit)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(IconButton), findsOneWidget);

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      verify(mockLogoutCubit.logout).called(1);
    });
  });
}
