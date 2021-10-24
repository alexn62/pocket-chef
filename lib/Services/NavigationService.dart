import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NavigationService {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<T?>? navigateTo<T>(String routeName,
      {dynamic arguments,
      int? id,
      bool preventDuplicates = true,
      Map<String, String>? parameters,
      bool replace = false}) {
    return replace
        ? Get.offNamed<T?>(
            routeName,
            arguments: arguments,
            id: id,
            preventDuplicates: preventDuplicates,
            parameters: parameters,
          )
        : Get.toNamed<T?>(
            routeName,
            arguments: arguments,
            id: id,
            preventDuplicates: preventDuplicates,
            parameters: parameters,
          );
  }

  bool back<T>({T? result, int? id}) {
    Get.back<T>(result: result, id: id);
    return Get.key.currentState?.canPop() ?? false;
  }
}
