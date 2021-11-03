import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Services/AuthService.dart';
import 'package:personal_recipes/ViewModels/BaseViewModel.dart';
import 'package:personal_recipes/locator.dart';
import 'package:personal_recipes/Constants/Routes.dart' as routes;
import 'package:stacked_services/stacked_services.dart';

class LandingScreenViewModel extends BaseViewModel {
  //----------SERVICES----------//
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  //----------------------------//

  void initialize() {
    setLoadingStatus(LoadingStatus.Busy);
    _authService.firebaseAuth.userChanges().listen((User? user) async {
      if (user == null) {
        navigateToLoginScreen();
      } else {
        if (user.emailVerified) {
          navigateToMainScreen();
        } else {
          navigateToLoginScreen();
          DialogResponse<dynamic>? response = await _dialogService.showDialog(
              title: 'Warning',
              description: 'Please verify your email to continue!',
              barrierDismissible: true,
              cancelTitle: 'Cancel',
              buttonTitle: 'Send verfification');
          if (response == null || !response.confirmed) {
          } else {
            user.sendEmailVerification();
          }
        }
      }
    });
    setLoadingStatus(LoadingStatus.Idle);
  }

  void navigateToMainScreen() {
    _navigationService.replaceWith(
      routes.MainScreenRoute,
    );
  }

  void navigateToLoginScreen() {
    _navigationService.replaceWith(
      routes.LoginRoute,
    );
  }
}
