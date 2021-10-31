import 'package:personal_recipes/Models/CustomError.dart';
import 'package:personal_recipes/Services/AuthService.dart';
import 'package:personal_recipes/Services/NavigationService.dart';
import 'package:personal_recipes/ViewModels/BaseViewModel.dart';
import 'package:personal_recipes/locator.dart';
import 'package:personal_recipes/Constants/Routes.dart' as routes;
class SignUpViewModel extends BaseViewModel{
  //----------SERVICES----------//
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  //----------------------------//

  String _email = '';
  String get email => _email;
  setEmail(String newEmail){
    _email = newEmail;
  }

  String _password = '';
  String get password => _password;
  setPassword(String newPassword){
    _password = newPassword;
  }

  String _confirmPassword = '';
  String get confirmPassword => _confirmPassword;
  setConfirmPassword(String newConfirmPassword){
    _confirmPassword = newConfirmPassword;
  }

  Future<void> signUpEmailPassword({required String email, required String password, required String confirmPassword})async{
   try{

    await _authService.signUpWithEmail(email: email, password: password, confirmPassword: confirmPassword);
   }on CustomError catch(e){
     print(e.message);
   }
  }


  void navigateToMainScreen() {
    _navigationService.navigateTo(routes.MainScreenRoute, replace: true);
  }
  void navigateToLoginScreen() {
    _navigationService.navigateTo(routes.LoginRoute, replace: true);
  }
}