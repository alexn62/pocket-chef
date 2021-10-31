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
                    const Expanded(child: SizedBox(),),
                    Text(
                      'Email',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                      ),
                    ),
                    vSmallSpace,
                    CustomTextFormField(onChanged: model.setEmail),
                    vSmallSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Password',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    vSmallSpace,
                    CustomTextFormField(onChanged: model.setPassword, password: true,),
                    vRegularSpace,
                    GenericButton(
                      onTap: () => model.loginEmailPassword(email: model.email, password: model.password),
                      title: 'Login',
                      positive: true,
                      stretch: true,
                    ),
                    const Expanded(child: SizedBox()),
                    const Center(child:  Text('Don\'t have an account yet?')),
                    vSmallSpace,
                    GenericButton(title: 'Sign up', onTap: model.navigateToSignUpScreen,invertColors: true, stretch: true,),
                    vRegularSpace,
                  ],
                ),
              ),
            )));
  }
}
