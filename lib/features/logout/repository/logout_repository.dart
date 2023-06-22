import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@singleton
class LogoutRepository {
  LogoutRepository({required this.firebaseAuth});

  final FirebaseAuth firebaseAuth;

  Future<void> logOut() async {
    await firebaseAuth.signOut();
  }
}
