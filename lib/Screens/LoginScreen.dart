import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/Screens/BaseView.dart';
import 'package:personal_recipes/ViewModels/LoginViewModel.dart';
import 'package:personal_recipes/Widgets/CustomTextFormField.dart';
import 'package:personal_recipes/Widgets/GenericButton.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
        builder: (context, model, child) => Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: Center(
              child: Container(
                margin: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                      ),
                    ),
                    vSmallSpace,
                    CustomTextFormField(onChanged: (_) {}),
                    vSmallSpace,
                    Text(
                      'Password',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                      ),
                    ),
                    vSmallSpace,
                    CustomTextFormField(onChanged: (_) {}),
                    vRegularSpace,
                    GenericButton(
                      onTap: () {},
                      title: 'Login',
                      positive: true,
                      stretch: true,
                    ),
                  ],
                ),
              ),
            )));
  }
}
