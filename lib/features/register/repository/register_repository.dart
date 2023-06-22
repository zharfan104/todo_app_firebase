import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@singleton
class RegisterRepository {
  RegisterRepository({required this.firebaseAuth});

  final FirebaseAuth firebaseAuth;

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
