import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Models/CustomError.dart';
import 'package:personal_recipes/Services/AuthService.dart';
import 'package:personal_recipes/ViewModels/BaseViewModel.dart';
import 'package:personal_recipes/locator.dart';
import 'package:personal_recipes/Constants/Routes.dart' as routes;
import 'package:stacked_services/stacked_services.dart';

class SignUpViewModel extends BaseViewModel {
  //----------SERVICES----------//
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  final AuthService _authService = locator<AuthService>();
  //----------------------------//

  String _email = '';
  String get email => _email;
  setEmail(String newEmail) {
    _email = newEmail;
  }

  String _password = '';
  String get password => _password;
  setPassword(String newPassword) {
    _password = newPassword;
  }

  String _confirmPassword = '';
  String get confirmPassword => _confirmPassword;
  setConfirmPassword(String newConfirmPassword) {
    _confirmPassword = newConfirmPassword;
  }

  Future<void> signUpEmailPassword(
      {required String email,
      required String password,
      required String confirmPassword}) async {
    try {
      setLoadingStatus(LoadingStatus.Busy);
      await _authService.signUpWithEmail(
          email: email, password: password, confirmPassword: confirmPassword);
      setLoadingStatus(LoadingStatus.Idle);
    } on CustomError catch (e) {
      setLoadingStatus(LoadingStatus.Idle);
      // if (e.code == 'email-not-verified') {
      //   DialogResponse<dynamic>? response = await _dialogService.showDialog(
      //       title: 'Warning',
      //       description: 'Please verify your email to continue!',
      //       barrierDismissible: true,
      //       cancelTitle: 'Cancel',
      //       buttonTitle: 'Send verification');
      //   if (response == null || !response.confirmed) {
      //     return;
      //   } else {
      //     _authService.firebaseAuth.currentUser!.sendEmailVerification();
      //   }
      // } else {
      _dialogService.showDialog(title: 'Error', description: e.message);
    }
  }

  // }
  Future<void> signUpWithGoogle() async {
    try {
      setLoadingStatus(LoadingStatus.Busy);
      await _authService.signInWithGoogle();
      setLoadingStatus(LoadingStatus.Idle);
    } on CustomError catch (e) {
      setLoadingStatus(LoadingStatus.Idle);
      _dialogService.showDialog(title: 'Error', description: e.message);
    } catch (e) {
      setLoadingStatus(LoadingStatus.Idle);
      _dialogService.showDialog(
          title: 'Error', description: 'An error occurred.');
    }
  }

  void navigateToLoginScreen() {
    _navigationService.replaceWith(
      routes.LoginRoute,
    );
  }
}
