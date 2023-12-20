// authentication_repository.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Метод для регистрации нового пользователя
  Future<void> signUp({required String email, required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Метод для входа пользователя
  Future<void> signIn({required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Метод для выхода пользователя
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Метод для проверки, зарегистрирован ли пользователь
  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  // Метод для получения текущего пользователя
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
