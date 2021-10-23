import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Themes.dart';
import 'package:personal_recipes/locator.dart';
import 'package:personal_recipes/services/general_services.dart';
import 'package:provider/provider.dart';

import 'Screens/MainScreen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await GeneralServices.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GeneralServices>.value(
      value: GeneralServices(),
      builder: (context, _) {
        final model = Provider.of<GeneralServices>(context);
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: model.themeMode,
            darkTheme: darkTheme,
            theme: lightTheme,
            home: const MainScreen());
      },
    );
  }
}
