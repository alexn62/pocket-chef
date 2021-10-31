import 'package:flutter/material.dart';
import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Screens/BaseView.dart';
import 'package:personal_recipes/ViewModels/LandingScreenViewModel.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<LandingScreenViewModel>(
      onModelReady: (model) => model.initialize(),
      builder: (context, model, child) => const Scaffold(
        body: Center(child: Text('Hi')),
      ),
    );
  }
}
