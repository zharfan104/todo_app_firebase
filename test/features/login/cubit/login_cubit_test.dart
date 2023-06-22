import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app_firebase/features/login/cubit/login_cubit.dart';
import 'package:todo_app_firebase/features/login/cubit/login_state.dart';
import 'package:todo_app_firebase/features/login/repository/login_repository.dart';
import 'package:todo_app_firebase/utils/load_data_state.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  late LoginCubit loginCubit;
  late LoginRepository loginRepository;

  setUp(() {
    loginRepository = MockLoginRepository();
    loginCubit = LoginCubit(loginRepository: loginRepository);
  });

  blocTest<LoginCubit, LoginState>(
    'emits [LoginState] with updated email when setEmail is called',
    build: () => loginCubit,
    act: (LoginCubit cubit) => cubit.setEmail('test@test.com'),
    expect: () => [
      LoginState(
        email: 'test@test.com',
        password: '',
        isObscured: true,
        submitDataStatus: InitialDataState(),
      )
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'emits [LoginState] with updated password when setPassword is called',
    build: () => loginCubit,
    act: (LoginCubit cubit) => cubit.setPassword('testPassword'),
    expect: () => [
      LoginState(
        email: '',
        password: 'testPassword',
        isObscured: true,
        submitDataStatus: InitialDataState(),
      )
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'emits [LoginState] with isObscured toggled when toggleObscured is called',
    build: () => loginCubit,
    act: (LoginCubit cubit) => cubit.toggleObscured(),
    expect: () => [
      LoginState(
        email: '',
        password: '',
        isObscured: false,
        submitDataStatus: InitialDataState(),
      )
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'emits [LoginState] with LoadedDataState when logIn is called',
    build: () {
      when(
        () => loginRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {
        return Future.value();
      });
      return loginCubit;
    },
    act: (LoginCubit cubit) {
      cubit
        ..setEmail('test@test.com')
        ..setPassword('testPassword');
      return cubit.logIn();
    },
    expect: () => [
      LoginState(
        email: 'test@test.com',
        password: '',
        isObscured: true,
        submitDataStatus: InitialDataState(),
      ),
      LoginState(
        email: 'test@test.com',
        password: 'testPassword',
        isObscured: true,
        submitDataStatus: InitialDataState(),
      ),
      LoginState(
        email: 'test@test.com',
        password: 'testPassword',
        isObscured: true,
        submitDataStatus: LoadingDataState(),
      ),
      const LoginState(
        email: 'test@test.com',
        password: 'testPassword',
        isObscured: true,
        submitDataStatus: LoadedDataState(data: null),
      )
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'emits [LoginState] with ErrorDataState when logIn throws a FirebaseAuthException',
    build: () {
      when(
        () => loginRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(
        FirebaseAuthException(
          code: 'test-error',
          message: 'Test error message',
        ),
      );
      return loginCubit;
    },
    act: (LoginCubit cubit) {
      cubit
        ..setEmail('test@test.com')
        ..setPassword('testPassword');
      return cubit.logIn();
    },
    expect: () => [
      LoginState(
        email: 'test@test.com',
        password: '',
        isObscured: true,
        submitDataStatus: InitialDataState(),
      ),
      LoginState(
        email: 'test@test.com',
        password: 'testPassword',
        isObscured: true,
        submitDataStatus: InitialDataState(),
      ),
      LoginState(
        email: 'test@test.com',
        password: 'testPassword',
        isObscured: true,
        submitDataStatus: LoadingDataState(),
      ),
      LoginState(
        email: 'test@test.com',
        password: 'testPassword',
        isObscured: true,
        submitDataStatus: ErrorDataState(
          errorMessage: FirebaseAuthException(
            code: 'test-error',
            message: 'Test error message',
          ).toString(),
        ),
      ),
      LoginState(
        email: 'test@test.com',
        password: 'testPassword',
        isObscured: true,
        submitDataStatus: InitialDataState(),
      )
    ],
  );
}
