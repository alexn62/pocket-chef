import 'package:firebase_auth/firebase_auth.dart';
import '../Services/AuthService.dart';
import 'package:personal_recipes/ViewModels/BaseViewModel.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../Enums/Enum.dart';
import '../Models/CustomError.dart';
import '../locator.dart';

class SettingsViewModel extends BaseViewModel {
  //----------SERVICVES----------//
  final AuthService _authService = locator<AuthService>();
  final DialogService _dialogService = locator<DialogService>();
  //----------------------------//
  User? get currentUser => _authService.firebaseAuth.currentUser;

  String? versionNumber;

  Future<void> initialize() async {
    setLoadingStatus(LoadingStatus.Busy);
    await getAppVersion();
    setLoadingStatus(LoadingStatus.Idle);
  }

  Future<void> getAppVersion() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    versionNumber = info.version;
  }

  Future<void> resetPassword(String email) async {
    try {
      setLoadingStatus(LoadingStatus.Busy);
      await _authService.forgotPassword(email);
      setLoadingStatus(LoadingStatus.Idle);
      _dialogService.showDialog(title: 'Message', description: 'We sent the instructions to reset your password to your email.');
    } on CustomError catch (e) {
      setLoadingStatus(LoadingStatus.Idle);
      _dialogService.showDialog(title: 'Error', description: e.message);
    }
  }

  void logout() {
    _authService.firebaseAuth.signOut();
  }

  void deleteUser() async {
    if (currentUser == null) return;
    try {
      DialogResponse<dynamic>? response = await _dialogService.showDialog(
          title: 'Warning', description: 'Are you sure you want to permanently delete your account? All recipes will be lost.', buttonTitle: 'Cancel', cancelTitle: 'Delete', barrierDismissible: true);
      if (response == null || response.confirmed) {
        return;
      } else {
       await _authService.deleteUser(currentUser!);
      }
    } on CustomError catch (e) {
      DialogResponse? response =
          await _dialogService.showDialog(title: 'Error', description: e.message, barrierDismissible: true, cancelTitle: e.message == 'Please reauthenticate to proceed' ? 'Cancel' : null);
      if (e.message == 'Please reauthenticate to proceed' && response != null && response.confirmed) {
        logout();
      }
    }
  }
}
