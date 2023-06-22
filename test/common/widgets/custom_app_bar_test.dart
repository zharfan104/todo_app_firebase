import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app_firebase/common/widgets/app_bar_title.dart';
import 'package:todo_app_firebase/common/widgets/custom_app_bar.dart';

void main() {
  testWidgets('CustomAppBar correctly shows the passed title and actions',
      (WidgetTester tester) async {
    // Define the test title and actions
    const testTitle = 'Test Title';
    final testActions = [const Icon(Icons.info)];

    // Build the CustomAppBar widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: CustomAppBar(
            title: testTitle,
            actions: testActions,
          ),
        ),
      ),
    );

    // Expect that an AppBar widget is in the widget tree
    expect(find.byType(AppBar), findsOneWidget);

    // Expect that a AppBarTitle widget is in the widget tree with the correct title
    expect(
      find.byWidgetPredicate(
        (widget) => widget is AppBarTitle && widget.title == testTitle,
      ),
      findsOneWidget,
    );

    // Expect that the correct actions are present in the AppBar
    expect(find.byIcon(Icons.info), findsOneWidget);
  });
}
