import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app_firebase/common/widgets/input_field.dart';

void main() {
  testWidgets('InputField displays the correct text and responds to text change', (WidgetTester tester) async {
    // Define the test label and initial value
    const testLabel = 'Test Label';
    const testInitialValue = 'Initial Value';
    var changedValue = '';

    void testOnChanged(String value) {
      changedValue = value;
    }

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InputField(
            label: testLabel,
            initialValue: testInitialValue,
            onChanged: testOnChanged,
          ),
        ),
      ),
    );

    // Expect that a InputField widget is in the widget tree
    expect(find.byType(InputField), findsOneWidget);

    // Expect that the correct label text is present
    expect(find.text(testLabel), findsOneWidget);

    // Input new text into the TextFormField
    await tester.enterText(find.byType(TextFormField), 'New Text');
    await tester.pumpAndSettle();

    // Expect that the onChanged callback was called with the correct value
    expect(changedValue, equals('New Text'));
  });

  testWidgets('InputField correctly toggles the visibility of the password', (WidgetTester tester) async {
    var isObscured = true;
    void toggleObscured() {
      isObscured = !isObscured;
    }

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InputField(
            label: 'Test Label',
            initialValue: 'Initial Value',
            onChanged: (String value) {},
            isObscured: isObscured,
            toggleObscured: toggleObscured,
          ),
        ),
      ),
    );

    // Find the visibility toggle icon and tap it
    await tester.tap(find.byType(GestureDetector));
    await tester.pumpAndSettle();

    // Expect that the obscured state was toggled correctly
    expect(isObscured, isFalse);
  });
}
