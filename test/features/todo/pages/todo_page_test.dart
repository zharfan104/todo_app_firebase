import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app_firebase/common/models/todo_model.dart';
import 'package:todo_app_firebase/features/logout/cubit/logout_cubit.dart';
import 'package:todo_app_firebase/features/todo/cubit/todo_cubit.dart';
import 'package:todo_app_firebase/features/todo/cubit/todo_state.dart';
import 'package:todo_app_firebase/features/todo/pages/todo_page.dart';
import 'package:todo_app_firebase/features/todo/pages/todo_page_body.dart';
import 'package:todo_app_firebase/utils/load_data_state.dart';

import '../../../helpers/helpers.dart';

class MockTodoCubit extends MockCubit<TodoState> implements TodoCubit {}

class MockLogoutCubit extends MockCubit<LoadDataState<void>>
    implements LogoutCubit {}

void main() {
  final mockTodoCubit = MockTodoCubit();
  final mockLogoutCubit = MockLogoutCubit();

  group('TodoPage', () {
    testWidgets('should build TodoPage without error', (tester) async {
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
          child: const TodoPage(),
        ),
      );

      expect(find.byType(TodoPageBody), findsOneWidget);
    });
  });
}
