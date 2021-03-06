import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:personal_recipes/Constants/Themes.dart';
import 'package:personal_recipes/Screens/LandingScreen.dart';
import 'package:personal_recipes/Screens/OnboardingScreen.dart';
import 'package:personal_recipes/Services/SnackbarSetup.dart';
import 'package:personal_recipes/locator.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';
import 'Router.dart' as router;
import 'Services/GeneralServices.dart';
import 'Services/SharedPrefs.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await setupLocator();
  setupSnackbarUi();
  await Firebase.initializeApp();
  await SharedPrefs.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final GeneralServices _generalService = locator<GeneralServices>();
    return ChangeNotifierProvider<GeneralServices>.value(
      value: locator<GeneralServices>(),
      child: Consumer<GeneralServices>(
        builder: (context, model, child) {
          return GetMaterialApp(
            navigatorKey: StackedService.navigatorKey,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: router.generateRoute,
            themeMode: model.themeMode,
            darkTheme: darkTheme,
            theme: lightTheme,
            home: _generalService.showOnboarding
                ? const OnboardingScreen()
                : const LandingScreen(),
          );
        },
      ),
    );
  }
}
