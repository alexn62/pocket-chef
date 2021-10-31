import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_recipes/Constants/ErrorHandling.dart';
import 'package:personal_recipes/Models/CustomError.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseAuth get firebaseAuth => _firebaseAuth;
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    validateEmailAndPassword(email, password);
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user == null) {
        throw const CustomError('No user found for the provided credential.');
      }
      if (!user.emailVerified) {
        throw const CustomError('Please verify your email!', code: 'email-not-verified');
      }
    } on FirebaseException catch (e) {
      throw CustomError(handleLoginError(e));
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user == null) {
        throw const CustomError('No user found for the provided credential.');
      }
      if (!user.emailVerified) {
        throw const CustomError('Please verify your email!', code: 'email-not-verified');
      }
    } on FirebaseException catch (e) {
      print(e.code);
      throw CustomError(handleLoginError(e));
    }
  }

  void validateEmailAndPassword(String email, String password) {
    validateEmail(email);
    validatePassword(password);
  }

  void validateEmail(String email) {
    RegExp regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!regex.hasMatch(email)) {
      throw const CustomError('Please use a valid email address.');
    }
    ;
  }

  void validatePassword(String password) {
    RegExp regex = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$");
    if (!regex.hasMatch(password)) {
      throw const CustomError('Please use a valid password. Must be at least six characters and include one number and one letter.');
    }
  }
}
