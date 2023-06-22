import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app_firebase/common/models/todo_model.dart';
import 'package:todo_app_firebase/features/todo/cubit/todo_cubit.dart';
import 'package:todo_app_firebase/features/todo/cubit/todo_state.dart';
import 'package:todo_app_firebase/features/todo/widgets/todo_fab.dart';
import 'package:todo_app_firebase/utils/load_data_state.dart';

import '../../../helpers/helpers.dart';

class MockStackRouter extends Mock implements StackRouter {}

class MockTodoCubit extends MockCubit<TodoState> implements TodoCubit {}

class FakePageRouteInfo extends Fake implements PageRouteInfo {}

void main() {
  final TodoCubit mockTodoCubit = MockTodoCubit();
  final StackRouter mockRouter = MockStackRouter();
  const newTodoTitle = 'New Todo';

  setUpAll(() {
    registerFallbackValue(
      TodoState(
        todoListStatus: LoadingDataState<List<TodoModel>>(),
        newTodoTitle: '',
      ),
    );

    registerFallbackValue(FakePageRouteInfo());
  });

  group('TodoFab', () {
    testWidgets('should build without error and call addNewTodo when onSubmitCallback is called', (tester) async {
      when(() => mockTodoCubit.addNewTodo(newTodoTitle)).thenAnswer((_) async {
        return Future.value();
      });

      when(mockRouter.pop).thenAnswer((_) => Future.value(false));

      await tester.pumpApp(
        StackRouterScope(
          controller: mockRouter,
          stateHash: 0,
          child: BlocProvider<TodoCubit>.value(
            value: mockTodoCubit,
            child: Scaffold(
              body: TodoFab(
                todoCubit: mockTodoCubit,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);

      // Tap on FloatingActionButton
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(Container), findsWidgets);

      await tester.enterText(find.byType(TextField), newTodoTitle);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(() => mockTodoCubit.addNewTodo(newTodoTitle));
      verify(mockRouter.pop).called(1);
    });
  });
}
