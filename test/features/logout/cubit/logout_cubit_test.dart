import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app_firebase/features/logout/cubit/logout_cubit.dart';
import 'package:todo_app_firebase/features/logout/repository/logout_repository.dart';
import 'package:todo_app_firebase/utils/load_data_state.dart';

class MockLogoutRepository extends Mock implements LogoutRepository {}

void main() {
  late LogoutCubit logoutCubit;
  late LogoutRepository logoutRepository;

  setUp(() {
    logoutRepository = MockLogoutRepository();
    logoutCubit = LogoutCubit(logoutRepository: logoutRepository);
  });

  blocTest<LogoutCubit, LoadDataState<void>>(
    'emits [LoadingDataState, LoadedDataState] when logout is called successfully',
    build: () {
      when(() => logoutRepository.logOut()).thenAnswer((_) async {});
      return logoutCubit;
    },
    act: (LogoutCubit cubit) => cubit.logout(),
    expect: () => [
      LoadingDataState<void>(),
      const LoadedDataState<void>(data: null),
    ],
  );

  blocTest<LogoutCubit, LoadDataState<void>>(
    'emits [LoadingDataState, ErrorDataState] when logout throws an exception',
    build: () {
      when(() => logoutRepository.logOut())
          .thenThrow(Exception('Logout error'));
      return logoutCubit;
    },
    act: (LogoutCubit cubit) => cubit.logout(),
    expect: () => [
      LoadingDataState<void>(),
      const ErrorDataState<void>(errorMessage: 'Exception: Logout error'),
    ],
  );
}
