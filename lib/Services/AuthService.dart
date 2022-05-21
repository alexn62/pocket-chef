import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Constants/ErrorHandling.dart';
import 'package:personal_recipes/Models/CustomError.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseAuth get firebaseAuth => _firebaseAuth;

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    validateEmailAndPassword(email);
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user == null) {
        throw const CustomError('No user found for the provided credential.');
      }
    } on FirebaseException catch (e) {
      throw CustomError(handleFirebaseError(e));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user == null) {
        throw const CustomError('No user found for the provided credential.');
      }
    } on FirebaseException catch (e) {
      throw CustomError(handleFirebaseError(e));
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      throw const CustomError(
          'The password and confirm password do not match.');
    }
    validateEmailAndPassword(email);
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user == null) {
        throw const CustomError('Unable to register. Please try again later.');
      }
    } on FirebaseException catch (e) {
      throw CustomError(handleFirebaseError(e));
    }
  }

  Future<void> forgotPassword(String email) async {
    validateEmail(email);
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (e) {
      throw CustomError(handleFirebaseError(e));
    }
  }

  Future<void> deleteUser(User currentUser) async {
    try {
      await currentUser.delete();
    } on FirebaseException catch (e) {
      throw CustomError(handleFirebaseError(e));
    }
  }

  void validateEmailAndPassword(
    String email,
  ) {
    validateEmail(email);
  }

  void validateEmail(String email) {
    RegExp regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!regex.hasMatch(email)) {
      throw const CustomError('Please use a valid email address.');
    }
  }
}
