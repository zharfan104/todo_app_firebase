import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app_firebase/common/widgets/custom_button.dart';

import '../../helpers/helpers.dart';

void main() {
  testWidgets(
      'CustomButton correctly shows the passed text and responds to tap when not loading',
      (WidgetTester tester) async {
    // Define the test title
    const testTitle = 'Test Title';
    var wasPressed = false;
    void testOnPressed() {
      wasPressed = true;
    }

    // Build the CustomButton widget
    await tester.pumpApp(
      Scaffold(
        body: CustomButton(
          text: testTitle,
          onPressed: testOnPressed,
          isLoading: false,
        ),
      ),
    );

    // Expect that a CustomButton widget is in the widget tree
    expect(find.byType(CustomButton), findsOneWidget);

    // Expect that a ElevatedButton widget is in the widget tree with the correct text
    expect(find.text(testTitle), findsOneWidget);

    // Tap the button and trigger a frame.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Expect that the onPressed callback was called
    expect(wasPressed, isTrue);
  });

  testWidgets(
      'CustomButton correctly shows CircularProgressIndicator when loading',
      (WidgetTester tester) async {
    // Define the test title
    const testTitle = 'Test Title';

    // Build the CustomButton widget
    await tester.pumpApp(
      Scaffold(
        body: CustomButton(
          text: testTitle,
          onPressed: () {},
          isLoading: true,
        ),
      ),
    );

    // Expect that a CustomButton widget is in the widget tree
    expect(find.byType(CustomButton), findsOneWidget);

    // Expect that a CircularProgressIndicator is present in the widget tree
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
