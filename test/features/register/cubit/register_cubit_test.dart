import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app_firebase/features/register/cubit/register_cubit.dart';
import 'package:todo_app_firebase/features/register/cubit/register_state.dart';
import 'package:todo_app_firebase/features/register/repository/register_repository.dart';
import 'package:todo_app_firebase/utils/load_data_state.dart';

class MockRegisterRepository extends Mock implements RegisterRepository {}

void main() {
  late RegisterCubit registerCubit;
  late RegisterRepository registerRepository;

  setUp(() {
    registerRepository = MockRegisterRepository();
    registerCubit = RegisterCubit(registerRepository: registerRepository);
  });

  blocTest<RegisterCubit, RegisterState>(
    'emits [RegisterState] with updated email when setEmail is called',
    build: () => registerCubit,
    act: (RegisterCubit cubit) => cubit.setEmail('test@test.com'),
    expect: () => [
      RegisterState(
        email: 'test@test.com',
        password: '',
        isObscured: true,
        submitDataStatus: InitialDataState(),
      )
    ],
  );

  blocTest<RegisterCubit, RegisterState>(
    'emits [RegisterState] with updated password when setPassword is called',
    build: () => registerCubit,
    act: (RegisterCubit cubit) => cubit.setPassword('testPassword'),
    expect: () => [
      RegisterState(
        email: '',
        password: 'testPassword',
        isObscured: true,
        submitDataStatus: InitialDataState(),
      )
    ],
  );

  blocTest<RegisterCubit, RegisterState>(
    'emits [RegisterState] with isObscured toggled when toggleObscured is called',
    build: () => registerCubit,
    act: (RegisterCubit cubit) => cubit.toggleObscured(),
    expect: () => [
      RegisterState(
        email: '',
        password: '',
        isObscured: false,
        submitDataStatus: InitialDataState(),
      )
    ],
  );

  blocTest<RegisterCubit, RegisterState>(
    'emits [RegisterState] with LoadedDataState when register is called',
    build: () {
      when(
        () => registerRepository.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {});
      return registerCubit;
    },
    act: (RegisterCubit cubit) {
      cubit
        ..setEmail('test@test.com')
        ..setPassword('testPassword');
      return cubit.register();
    },
    expect: () => [
      RegisterState(
        email: 'test@test.com',
        password: '',
        isObscured: true,
        submitDataStatus: InitialDataState(),
      ),
      RegisterState(
        email: 'test@test.com',
        password: 'testPassword',
        isObscured: true,
        submitDataStatus: InitialDataState(),
      ),
      RegisterState(
        email: 'test@test.com',
        password: 'testPassword',
        isObscured: true,
        submitDataStatus: LoadingDataState(),
      ),
      const RegisterState(
        email: 'test@test.com',
        password: 'testPassword',
        isObscured: true,
        submitDataStatus: LoadedDataState(data: null),
      )
    ],
  );

  blocTest<RegisterCubit, RegisterState>(
    'emits [RegisterState] with ErrorDataState when register throws a FirebaseAuthException',
    build: () {
      when(
        () => registerRepository.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(
        FirebaseAuthException(
          code: 'test-error',
          message: 'Test error message',
        ),
      );
      return registerCubit;
    },
    act: (RegisterCubit cubit) {
      cubit
        ..setEmail('test@test.com')
        ..setPassword('testPassword');
      return cubit.register();
    },
    expect: () => [
      RegisterState(
        email: 'test@test.com',
        password: '',
        isObscured: true,
        submitDataStatus: InitialDataState(),
      ),
      RegisterState(
        email: 'test@test.com',
        password: 'testPassword',
        isObscured: true,
        submitDataStatus: InitialDataState(),
      ),
      RegisterState(
        email: 'test@test.com',
        password: 'testPassword',
        isObscured: true,
        submitDataStatus: LoadingDataState(),
      ),
      RegisterState(
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
      RegisterState(
        email: 'test@test.com',
        password: 'testPassword',
        isObscured: true,
        submitDataStatus: InitialDataState(),
      )
    ],
  );
}
