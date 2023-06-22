import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app_firebase/common/models/todo_model.dart';
import 'package:todo_app_firebase/features/todo/cubit/todo_cubit.dart';
import 'package:todo_app_firebase/features/todo/cubit/todo_state.dart';
import 'package:todo_app_firebase/features/todo/widgets/todo_item.dart';
import 'package:todo_app_firebase/features/todo/widgets/todo_list_view.dart';

import '../../../helpers/pump_app.dart';

class MockTodoCubit extends MockCubit<TodoState> implements TodoCubit {}

void main() {
  final mockTodoCubit = MockTodoCubit();

  final todos = List<TodoModel>.generate(
    10,
    (index) => TodoModel(
      uid: 'id_$index',
      title: 'Todo $index',
      isCompleted: index.isEven,
    ),
  );

  setUp(() {
    when(() => mockTodoCubit.removeTodo(any())).thenAnswer(
      (_) => Future.value(),
    );
    when(() => mockTodoCubit.toggleTaskCompletion(any())).thenAnswer(
      (_) => Future.value(),
    );
  });

  group('TodoListView', () {
    testWidgets(
        'should build and display the correct number of TodoItem widgets',
        (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: TodoListView(
            todos: todos,
            todoCubit: mockTodoCubit,
          ),
        ),
      );

      // Verify the correct number of TodoItem widgets are rendered.
      expect(find.byType(TodoItem), findsNWidgets(todos.length));
    });

    testWidgets(
        'should call removeTodo and toggleTaskCompletion when appropriate',
        (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: TodoListView(
            todos: todos,
            todoCubit: mockTodoCubit,
          ),
        ),
      );

      // Simulate swipe to dismiss action.
      await tester.drag(find.byType(Dismissible).first, const Offset(500, 0));
      await tester.pumpAndSettle();
      verify(() => mockTodoCubit.removeTodo('id_0'));

      // Simulate tapping on a list item.
      await tester.tap(find.byType(ListTile).first);
      await tester.pump();
      verify(() => mockTodoCubit.toggleTaskCompletion('id_1'));
    });
  });
}
