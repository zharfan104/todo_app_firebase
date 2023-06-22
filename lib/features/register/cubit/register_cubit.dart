import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_firebase/features/register/cubit/register_state.dart';
import 'package:todo_app_firebase/features/register/repository/register_repository.dart';
import 'package:todo_app_firebase/utils/load_data_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({required this.registerRepository})
      : super(
          RegisterState(
            email: '',
            password: '',
            isObscured: true,
            submitDataStatus: InitialDataState(),
          ),
        );

  final RegisterRepository registerRepository;

  void setEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void setPassword(String password) {
    emit(state.copyWith(password: password));
  }

  void toggleObscured() {
    emit(state.copyWith(isObscured: !state.isObscured));
  }

  Future<void> register() async {
    try {
      emit(state.copyWith(submitDataStatus: LoadingDataState()));
      await registerRepository.signUp(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(submitDataStatus: const LoadedDataState(data: null)));
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          submitDataStatus: ErrorDataState(errorMessage: e.toString()),
        ),
      );
      emit(state.copyWith(submitDataStatus: InitialDataState()));
    }
  }
}
