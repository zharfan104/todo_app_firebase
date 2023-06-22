import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@singleton
class LoginRepository {
  LoginRepository({required this.firebaseAuth});

  final FirebaseAuth firebaseAuth;

  bool get isLoggedIn {
    return firebaseAuth.currentUser != null;
  }

  Future<void> login({
    required String email,
    required String password,
  }) {
    return firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
