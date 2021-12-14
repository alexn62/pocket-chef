import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Screens/BaseView.dart';
import 'package:personal_recipes/ViewModels/SignUpViewModel.dart';
import 'package:personal_recipes/Widgets/AuthScreens/AppleGoogleButton.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/CustomTextFormField.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/FullScreenLoadingIndicator.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/GenericButton.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SignUpViewModel>(
        builder: (context, model, child) => WillPopScope(
              onWillPop: () async => false,
              child: Stack(
                children: [
                  Scaffold(
                      backgroundColor: Theme.of(context).backgroundColor,
                      body: SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
                                child: SizedBox(),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'hi',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    vRegularSpace,
                                    Image.asset(
                                      'assets/icons/hug.png',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryVariant,
                                      height: 64,
                                    ),
                                    vRegularSpace,
                                    const Text(
                                      'thanks for joining',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    vSmallSpace,
                                    const Text(
                                      'please register to create your recipes',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              const Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              vTinySpace,
                              CustomTextFormField(
                                onChanged: model.setEmail,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              vSmallSpace,
                              Text(
                                'Password',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16,
                                ),
                              ),
                              vTinySpace,
                              CustomTextFormField(
                                onChanged: model.setPassword,
                                password: true,
                              ),
                              vSmallSpace,
                              Text(
                                'Confirm Password',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16,
                                ),
                              ),
                              vTinySpace,
                              CustomTextFormField(
                                onFieldSubmitted: (_) =>
                                    model.signUpEmailPassword(
                                        email: model.email,
                                        password: model.password,
                                        confirmPassword: model.confirmPassword),
                                onChanged: model.setConfirmPassword,
                                password: true,
                              ),
                              vRegularSpace,
                              GenericButton(
                                onTap: () => model.signUpEmailPassword(
                                    email: model.email,
                                    password: model.password,
                                    confirmPassword: model.confirmPassword),
                                title: 'Sign up',
                                positive: true,
                                stretch: true,
                              ),
                              vRegularSpace,
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Or continue with...',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              vRegularSpace,
                              Row(
                                children: [
                                  Expanded(
                                    child: AppleGoogleButton(
                                        onTap: () {},
                                        platform: AppleGoogle.Google),
                                  ),
                                  hSmallSpace,
                                  Expanded(
                                    child: AppleGoogleButton(
                                        onTap: () {},
                                        platform: AppleGoogle.Apple),
                                  ),
                                ],
                              ),
                              const Expanded(child: SizedBox()),
                              const Center(
                                  child: Text('Already have an account?')),
                              vSmallSpace,
                              GenericButton(
                                title: 'Login',
                                onTap: model.navigateToLoginScreen,
                                invertColors: true,
                                stretch: true,
                              ),
                              vRegularSpace,
                            ],
                          ),
                        ),
                      )),
                  FullScreenLoadingIndicator(model.loadingStatus),
                ],
              ),
            ));
  }
}
