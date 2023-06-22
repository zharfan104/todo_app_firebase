import 'package:equatable/equatable.dart';
import 'package:todo_app_firebase/utils/load_data_state.dart';

class LoginState extends Equatable {
  const LoginState({
    required this.email,
    required this.password,
    required this.isObscured,
    required this.submitDataStatus,
  });

  final String email;
  final String password;
  final bool isObscured;
  final LoadDataState<void> submitDataStatus;

  LoginState copyWith({
    String? email,
    String? password,
    bool? isObscured,
    LoadDataState<void>? submitDataStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isObscured: isObscured ?? this.isObscured,
      submitDataStatus: submitDataStatus ?? this.submitDataStatus,
    );
  }

  @override
  List<Object?> get props => [email, password, isObscured, submitDataStatus];
}
