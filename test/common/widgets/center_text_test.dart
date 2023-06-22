import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app_firebase/common/widgets/center_text.dart';

import '../../helpers/helpers.dart';

void main() {
  testWidgets('CenterText correctly shows the passed text',
      (WidgetTester tester) async {
    // Define the test text
    const testText = 'Test text';

    // Build the CenterText widget
    await tester.pumpApp(
      const Scaffold(
        body: CenterText(
          text: testText,
        ),
      ),
    );

    // Expect that a Center widget is in the widget tree
    expect(find.byType(Center), findsOneWidget);

    // Expect that a Text widget is in the widget tree with the correct text
    expect(find.text(testText), findsOneWidget);
  });
}
