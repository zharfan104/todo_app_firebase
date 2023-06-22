import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app_firebase/common/models/todo_model.dart';
import 'package:todo_app_firebase/features/todo/cubit/todo_cubit.dart';
import 'package:todo_app_firebase/features/todo/cubit/todo_state.dart';
import 'package:todo_app_firebase/features/todo/repository/todo_repository.dart';
import 'package:todo_app_firebase/utils/load_data_state.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late TodoCubit todoCubit;
  late TodoRepository todoRepository;
  final mockTodoList = [
    const TodoModel(uid: '1', title: 'Test Todo', isCompleted: false),
  ];
  final mockToggledTodoList = [
    const TodoModel(uid: '1', title: 'Test Todo', isCompleted: true),
  ];

  setUp(() {
    todoRepository = MockTodoRepository();
    todoCubit = TodoCubit(todoRepository: todoRepository);
  });

  blocTest<TodoCubit, TodoState>(
    'emits state with loaded todos when getTodos successfully retrieves data',
    build: () {
      when(() => todoRepository.getTodos()).thenAnswer((_) async => mockTodoList);
      return todoCubit;
    },
    act: (TodoCubit cubit) => cubit.getTodos(isInitialLoadingShown: true),
    expect: () => [
      TodoState(
        newTodoTitle: '',
        todoListStatus: LoadingDataState<List<TodoModel>>(),
      ),
      TodoState(
        newTodoTitle: '',
        todoListStatus: LoadedDataState<List<TodoModel>>(data: mockTodoList),
      )
    ],
    verify: (_) {
      verify(() => todoRepository.getTodos()).called(1);
    },
  );

  blocTest<TodoCubit, TodoState>(
    'emits state with new todo when addNewTodo is successful',
    build: () {
      when(() => todoRepository.addNewTodo(any())).thenAnswer((_) async {});
      when(() => todoRepository.getTodos()).thenAnswer((_) async => mockTodoList);
      return todoCubit;
    },
    act: (TodoCubit cubit) => cubit.addNewTodo('Test Todo'),
    expect: () => [
      TodoState(
        newTodoTitle: '',
        todoListStatus: LoadedDataState<List<TodoModel>>(data: mockTodoList),
      ),
    ],
    verify: (_) {
      verify(() => todoRepository.addNewTodo('Test Todo')).called(1);
      verify(() => todoRepository.getTodos()).called(1);
    },
  );

  blocTest<TodoCubit, TodoState>(
    'emits state with updated todo when toggleTaskCompletion is successful',
    build: () {
      when(() => todoRepository.toggleTaskCompletion(any())).thenAnswer((_) async {});
      when(() => todoRepository.getTodos()).thenAnswer((_) async => mockTodoList);
      return todoCubit;
    },
    act: (TodoCubit cubit) async {
      await cubit.getTodos();
      await cubit.toggleTaskCompletion('1');
    },
    expect: () => [
      TodoState(
        newTodoTitle: '',
        todoListStatus: LoadedDataState<List<TodoModel>>(data: mockTodoList),
      ),
      TodoState(
        newTodoTitle: '',
        todoListStatus: LoadedDataState<List<TodoModel>>(data: mockToggledTodoList),
      ),
      TodoState(
        newTodoTitle: '',
        todoListStatus: LoadedDataState<List<TodoModel>>(data: mockTodoList),
      ),
    ],
    verify: (_) {
      verify(() => todoRepository.toggleTaskCompletion('1')).called(1);
      verify(() => todoRepository.getTodos()).called(2);
    },
  );

  blocTest<TodoCubit, TodoState>(
    'emits state without removed todo when removeTodo is successful',
    build: () {
      when(() => todoRepository.removeTodo(any())).thenAnswer((_) async {});
      when(() => todoRepository.getTodos()).thenAnswer((_) async => mockTodoList);
      return todoCubit;
    },
    act: (TodoCubit cubit) => cubit.removeTodo('1'),
    expect: () => [
      TodoState(
        newTodoTitle: '',
        todoListStatus: LoadedDataState<List<TodoModel>>(data: mockTodoList),
      ),
    ],
    verify: (_) {
      verify(() => todoRepository.removeTodo('1')).called(1);
      verify(() => todoRepository.getTodos()).called(1);
    },
  );

  // TODO(zharfan104): Add similar test cases for failures, verifying that the cubit emits the correct error states
}
