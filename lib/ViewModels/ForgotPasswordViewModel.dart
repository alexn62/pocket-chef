import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Models/CustomError.dart';
import 'package:personal_recipes/Services/AuthService.dart';
import 'package:personal_recipes/ViewModels/BaseViewModel.dart';
import 'package:personal_recipes/locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:personal_recipes/Constants/Routes.dart' as routes;

class ForgotPasswordViewModel extends BaseViewModel {
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

  Future<void> forgotPassword(String email) async {
    try {
      setLoadingStatus(LoadingStatus.Busy);
      await _authService.forgotPassword(email);
      setLoadingStatus(LoadingStatus.Idle);
      _dialogService.showDialog(
          title: 'Message',
          description:
              'We sent the instructions to reset your password to your email.');
    } on CustomError catch (e) {
      _dialogService.showDialog(title: 'Error', description: e.message);
    }
  }

  void navigateToLoginScreen() {
    _navigationService.navigateTo(
      routes.LoginRoute,
    );
  }
}
