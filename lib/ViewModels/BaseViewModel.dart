import 'package:flutter/material.dart';
import 'package:personal_recipes/Enums/Enum.dart';

abstract class BaseViewModel extends ChangeNotifier {
  LoadingStatus _loadingStatus = LoadingStatus.Idle;
  LoadingStatus get loadingStatus => _loadingStatus;
  void setLoadingStatus(LoadingStatus newLoadingStatus) {
    _loadingStatus = newLoadingStatus;
    notifyListeners();
  }
}
