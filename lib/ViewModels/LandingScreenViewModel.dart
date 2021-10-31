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
  //----------------------------//


  void initialize() {
    setLoadingStatus(LoadingStatus.Busy);
    _authService.firebaseAuth.authStateChanges().listen((User? user) {
      if (user == null) {
        navigateToLoginScreen();
        print('User is currently signed out');
      } else {
        navigateToMainScreen();
        print('User logged in: ${user.email}');
      }
    });
    setLoadingStatus(LoadingStatus.Idle);
  }

  void navigateToMainScreen(){
    _navigationService.replaceWith(routes.MainScreenRoute,);
  }
  void navigateToLoginScreen(){
    _navigationService.replaceWith(routes.LoginRoute,);
  }
}
