import 'package:personal_recipes/Enums/Enum.dart';
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
      setLoadingStatus(LoadingStatus.Busy);
      await _authService.loginWithEmail(email: email, password: password);
      setLoadingStatus(LoadingStatus.Idle);
    } on CustomError catch (e) {
      setLoadingStatus(LoadingStatus.Idle);
      _dialogService.showDialog(title: 'Error', description: e.message);
    }
  }

  void navigateToSignUpScreen() {
    _navigationService.replaceWith(
      routes.SignUpRoute,
    );
  }

  void navigateToForgotPasswordScreen() {
    _navigationService.replaceWith(routes.ForgotPasswordRoute);
  }
}
