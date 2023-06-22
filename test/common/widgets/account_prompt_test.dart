import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app_firebase/common/widgets/account_prompt.dart';
import 'package:todo_app_firebase/core/router/app_router.dart';

import '../../helpers/pump_app.dart';

class MockStackRouter extends Mock implements StackRouter {}

class FakePageRouteInfo extends Fake implements PageRouteInfo {}

void main() {
  final StackRouter mockRouter = MockStackRouter();

  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
  });

  group('ActionPrompt', () {
    testWidgets(
        'should build without error and navigate when the text button is pressed',
        (tester) async {
      const promptText = 'Prompt Text';
      const actionText = 'Action Text';
      const targetRoute = TodoRoute();

      when(() => mockRouter.push(targetRoute))
          .thenAnswer((_) => Future.value(false));

      await tester.pumpApp(
        StackRouterScope(
          controller: mockRouter,
          stateHash: 0,
          child: const Scaffold(
            body: ActionPrompt(
              promptText: promptText,
              actionText: actionText,
              targetRoute: targetRoute,
            ),
          ),
        ),
      );

      // Verify prompt text
      expect(find.text(promptText), findsOneWidget);

      // Verify action text
      expect(find.text(actionText), findsOneWidget);

      // Tap on the TextButton
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      // Verify navigation
      verify(() => mockRouter.push(targetRoute)).called(1);
    });
  });
}
