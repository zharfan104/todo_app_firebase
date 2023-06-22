import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app_firebase/common/widgets/app_bar_title.dart';

import '../../helpers/helpers.dart';

void main() {
  testWidgets('AppBarTitle widget should show correct title',
      (WidgetTester tester) async {
    // Define the test title
    const testTitle = 'Test Title';

    // Build the AppBarTitle widget
    await tester.pumpApp(
      Scaffold(
        appBar: AppBar(
          title: const AppBarTitle(title: testTitle),
        ),
      ),
    );

    // Create the Finders
    final titleFinder = find.text(testTitle);

    // Verify that the AppBarTitle shows the correct title
    expect(titleFinder, findsOneWidget);
  });
}
