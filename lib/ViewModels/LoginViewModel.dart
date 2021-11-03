import 'package:personal_recipes/Models/CustomError.dart';
import 'package:personal_recipes/Services/AuthService.dart';
import 'package:personal_recipes/ViewModels/BaseViewModel.dart';
import 'package:personal_recipes/locator.dart';
import 'package:personal_recipes/Constants/Routes.dart' as routes;
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BaseViewModel {
  //----------SERVICES----------//
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DialogService _dialogService = locator<DialogService>();
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

  Future<void> loginEmailPassword(
      {required String email, required String password}) async {
    try {
      await _authService.loginWithEmail(email: email, password: password);
    } on CustomError catch (e) {
      if (e.code == 'email-not-verified') {
        DialogResponse<dynamic>? response = await _dialogService.showDialog(
            title: 'Warning',
            description: 'Please verify your email to continue!',
            barrierDismissible: true,
            cancelTitle: 'Cancel',
            buttonTitle: 'Send verification');
        if (response == null || !response.confirmed) {
          return;
        } else {
          _authService.firebaseAuth.currentUser!.sendEmailVerification();
        }
      } else {
        _dialogService.showDialog(title: 'Error', description: e.message);
      }
    }
  }

  void navigateToMainScreen() {
    _navigationService.navigateTo(
      routes.MainScreenRoute,
    );
  }

  void navigateToSignUpScreen() {
    _navigationService.navigateTo(
      routes.SignUpRoute,
    );
  }

  void navigateToForgotPasswordScreen() {
    _navigationService.navigateTo(routes.ForgotPasswordRoute);
  }
}
