import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app_firebase/common/models/todo_model.dart';
import 'package:todo_app_firebase/features/logout/cubit/logout_cubit.dart';
import 'package:todo_app_firebase/features/todo/cubit/todo_cubit.dart';
import 'package:todo_app_firebase/features/todo/cubit/todo_state.dart';
import 'package:todo_app_firebase/features/todo/pages/todo_page_body.dart';
import 'package:todo_app_firebase/features/todo/widgets/todo_list_view.dart';
import 'package:todo_app_firebase/utils/load_data_state.dart';

import '../../../helpers/helpers.dart';

class MockTodoCubit extends MockCubit<TodoState> implements TodoCubit {}

class MockLogoutCubit extends MockCubit<LoadDataState<void>>
    implements LogoutCubit {}

void main() {
  final mockTodoCubit = MockTodoCubit();
  final mockLogoutCubit = MockLogoutCubit();

  setUp(() {
    when(() => mockLogoutCubit.state).thenReturn(
      LoadingDataState<void>(),
    );
    when(
      () => mockTodoCubit.getTodos(
        isInitialLoadingShown: any(named: 'isInitialLoadingShown'),
      ),
    ).thenAnswer(
      (_) => Future.value(),
    );
  });

  group('TodoPageBody', () {
    testWidgets('should call getTodos in initState', (tester) async {
      when(() => mockTodoCubit.state).thenReturn(
        TodoState(
          todoListStatus: LoadingDataState<List<TodoModel>>(),
          newTodoTitle: '',
        ),
      );

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodoCubit>.value(value: mockTodoCubit),
            BlocProvider<LogoutCubit>.value(value: mockLogoutCubit),
          ],
          child: const TodoPageBody(),
        ),
      );

      verify(
        () => mockTodoCubit.getTodos(
          isInitialLoadingShown: any(named: 'isInitialLoadingShown'),
        ),
      );
    });

    testWidgets('shows correct title', (tester) async {
      when(() => mockTodoCubit.state).thenReturn(
        TodoState(
          todoListStatus: LoadingDataState<List<TodoModel>>(),
          newTodoTitle: '',
        ),
      );

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodoCubit>.value(value: mockTodoCubit),
            BlocProvider<LogoutCubit>.value(value: mockLogoutCubit),
          ],
          child: const TodoPageBody(),
        ),
      );

      expect(find.text('To Do'), findsOneWidget);
    });

    testWidgets('shows loading when TodoState is loading', (tester) async {
      when(() => mockTodoCubit.state).thenReturn(
        TodoState(
          todoListStatus: LoadingDataState<List<TodoModel>>(),
          newTodoTitle: '',
        ),
      );

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodoCubit>.value(value: mockTodoCubit),
            BlocProvider<LogoutCubit>.value(value: mockLogoutCubit),
          ],
          child: const TodoPageBody(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows TodoListView when TodoState has data and is not empty',
        (tester) async {
      when(() => mockTodoCubit.state).thenReturn(
        const TodoState(
          todoListStatus: LoadedDataState<List<TodoModel>>(
            data: [TodoModel(uid: '1', title: 'Test', isCompleted: false)],
          ),
          newTodoTitle: '',
        ),
      );

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodoCubit>.value(value: mockTodoCubit),
            BlocProvider<LogoutCubit>.value(value: mockLogoutCubit),
          ],
          child: const TodoPageBody(),
        ),
      );

      expect(find.byType(TodoListView), findsOneWidget);
    });

    testWidgets('shows TodoEmptyText when TodoState has data and is empty',
        (tester) async {
      when(() => mockTodoCubit.state).thenReturn(
        const TodoState(
          todoListStatus: LoadedDataState<List<TodoModel>>(data: []),
          newTodoTitle: '',
        ),
      );

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodoCubit>.value(value: mockTodoCubit),
            BlocProvider<LogoutCubit>.value(value: mockLogoutCubit),
          ],
          child: const TodoPageBody(),
        ),
      );

      expect(find.text('Add your first TODO!'), findsOneWidget);
    });

    testWidgets('shows TodoEmptyText when TodoState has data and is empty',
        (tester) async {
      when(() => mockTodoCubit.state).thenReturn(
        const TodoState(
          todoListStatus:
              ErrorDataState<List<TodoModel>>(errorMessage: 'Error Message'),
          newTodoTitle: '',
        ),
      );

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<TodoCubit>.value(value: mockTodoCubit),
            BlocProvider<LogoutCubit>.value(value: mockLogoutCubit),
          ],
          child: const TodoPageBody(),
        ),
      );

      expect(find.text('Error Message'), findsOneWidget);
    });
  });
}
