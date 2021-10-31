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
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user == null){
        throw const CustomError('No user found for the provided credential.');
      }
      if (!user.emailVerified){
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
      if (user == null){
        throw const CustomError('No user found for the provided credential.');
      }
      if (!user.emailVerified){
        throw const CustomError('Please verify your email!', code: 'email-not-verified');
      }
    } on FirebaseException catch (e) {
      print(e.code);
      throw CustomError(handleLoginError(e));
    }
  }
}
