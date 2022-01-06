import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Screens/BaseView.dart';
import 'package:personal_recipes/ViewModels/LoginViewModel.dart';
import 'package:personal_recipes/Widgets/AuthScreens/AppleGoogleButton.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/CustomTextFormField.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/FullScreenLoadingIndicator.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/GenericButton.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
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
                                child: blankSpace,
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
                                    Image.asset('assets/icons/smiley.png',
                                        height: 64,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary),
                                    vRegularSpace,
                                    const Text(
                                      'welcome back',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    vSmallSpace,
                                    const Text(
                                      'please login to view your recipes',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              const Expanded(
                                child: blankSpace,
                              ),
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(35 / 2),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary
                                        .withOpacity(.05)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      ' Email',
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                    vSmallSpace,
                                    CustomTextFormField(
                                      fillColor:
                                          Theme.of(context).backgroundColor,
                                      onChanged: model.setEmail,
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    vRegularSpace,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          ' Password',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 17,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: model
                                              .navigateToForgotPasswordScreen,
                                          child: Text(
                                            'Forgot password? ',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    vSmallSpace,
                                    CustomTextFormField(
                                      fillColor:
                                          Theme.of(context).backgroundColor,
                                      onFieldSubmitted: (_) =>
                                          model.loginEmailPassword(
                                              email: model.email,
                                              password: model.password),
                                      onChanged: model.setPassword,
                                      password: true,
                                    ),
                                  ],
                                ),
                              ),
                              vRegularSpace,
                              GenericButton(
                                positive: true,
                                // color: Theme.of(context).brightness ==
                                //         Brightness.dark
                                //     ? Colors.white
                                //     : null,
                                rounded: true,
                                onTap: () => model.loginEmailPassword(
                                    email: model.email,
                                    password: model.password),
                                title: 'Login',
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
                                        onTap: model.loginWithGoogle,
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
                              const Expanded(child: blankSpace),
                              const Center(
                                  child: Text('Don\'t have an account yet?')),
                              vSmallSpace,
                              GenericButton(
                                invertColors: true,
                                rounded: true,
                                title: 'Sign up',
                                onTap: model.navigateToSignUpScreen,
                                stretch: true,
                              ),
                              vRegularSpace,
                            ],
                          ),
                        ),
                      )),
                  FullScreenLoadingIndicator(model.loadingStatus)
                ],
              ),
            ));
  }
}
