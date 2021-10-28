import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:personal_recipes/Constants/Themes.dart';
import 'package:personal_recipes/Services/NavigationService.dart';
import 'package:personal_recipes/locator.dart';
import 'package:provider/provider.dart';
import 'Router.dart' as router;
import 'Screens/MainScreen.dart';
import 'Services/GeneralServices.dart';
import 'Services/SharedPrefs.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await Firebase.initializeApp();
  await SharedPrefs.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GeneralServices>.value(
        value: locator<GeneralServices>(),
        child: Consumer<GeneralServices>(builder: (context, model, child) {
          return GetMaterialApp(
              navigatorKey: locator<NavigationService>().navigatorKey,
              debugShowCheckedModeBanner: false,
              onGenerateRoute: router.generateRoute,
              themeMode: model.themeMode,
              darkTheme: darkTheme,
              theme: lightTheme,
              home: const MainScreen());
        }));
  }
}
