import 'package:personal_recipes/Services/AuthService.dart';
import 'package:personal_recipes/ViewModels/BaseViewModel.dart';

import '../locator.dart';

class SettingsViewModel extends BaseViewModel {
  //----------SETTINGS----------//
  final AuthService _authService = locator<AuthService>();
  //----------------------------//
  void initialize() {}

  void logout() {
    _authService.firebaseAuth.signOut();
  }
}
