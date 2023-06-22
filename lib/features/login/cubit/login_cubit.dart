import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app_firebase/features/login/cubit/login_state.dart';
import 'package:todo_app_firebase/features/login/repository/login_repository.dart';
import 'package:todo_app_firebase/utils/load_data_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.loginRepository})
      : super(
          LoginState(
            email: '',
            password: '',
            isObscured: true,
            submitDataStatus: InitialDataState(),
          ),
        );

  final LoginRepository loginRepository;

  void checkIfAlreadyLoggedIn() {
    if (loginRepository.isLoggedIn) {
      emit(state.copyWith(submitDataStatus: const LoadedDataState(data: null)));
    }
  }

  void setEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void setPassword(String password) {
    emit(state.copyWith(password: password));
  }

  void toggleObscured() {
    emit(state.copyWith(isObscured: !state.isObscured));
  }

  Future<void> logIn() async {
    try {
      emit(state.copyWith(submitDataStatus: LoadingDataState()));
      await loginRepository.login(
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
