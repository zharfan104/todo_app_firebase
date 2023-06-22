import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app_firebase/common/models/todo_model.dart';
import 'package:todo_app_firebase/features/todo/widgets/todo_item.dart';

import '../../../helpers/pump_app.dart';

void main() {
  const mockTodoModel = TodoModel(
    uid: '123',
    title: 'Test title',
    isCompleted: false,
  );

  var isRemoveCalled = false;
  var isToggleCalled = false;

  void mockOnRemove(String uid) {
    isRemoveCalled = true;
  }

  void mockOnToggle(String uid) {
    isToggleCalled = true;
  }

  group('TodoItem', () {
    testWidgets('should build TodoItem without error and perform operations',
        (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: TodoItem(
            todo: mockTodoModel,
            onRemove: mockOnRemove,
            onToggle: mockOnToggle,
          ),
        ),
      );

      // Verify if the TodoItem is displayed.
      expect(find.text('Test title'), findsOneWidget);

      // Perform onTap action to check if onToggle callback is called.
      await tester.tap(find.byType(ListTile));
      expect(isToggleCalled, true);

      // Perform onDismissed action to check if onRemove callback is called.
      await tester.drag(find.byType(Dismissible), const Offset(500, 0));
      await tester.pumpAndSettle(); // Wait for the animation to complete.
      expect(isRemoveCalled, true);
    });
  });
}
