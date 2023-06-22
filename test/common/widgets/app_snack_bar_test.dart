import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app_firebase/common/widgets/app_snack_bar.dart';

void main() {
  testWidgets('AppSnackBar show displays a Snackbar with correct content', (WidgetTester tester) async {
    const snackBarText = 'Test SnackBar';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => AppSnackBar.show(context, text: snackBarText),
              child: const Text('Show Snackbar'),
            ),
          ),
        ),
      ),
    );

    // Tap on the button to show the SnackBar
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Expect that a SnackBar is in the widget tree
    expect(find.byType(SnackBar), findsOneWidget);

    // Expect that the correct text is present in the SnackBar
    expect(find.text(snackBarText), findsOneWidget);
  });
}
