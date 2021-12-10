import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/Screens/BaseView.dart';
import 'package:personal_recipes/ViewModels/LoginViewModel.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/CustomTextFormField.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/GenericButton.dart';
import 'package:personal_recipes/widgets/FullScreenLoadingIndicator.dart';

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
                                    Image.asset('assets/icons/smiley.png',
                                        height: 64,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryVariant),
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
                                child: SizedBox(),
                              ),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Password',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: model.navigateToForgotPasswordScreen,
                                    child: Text(
                                      'Forgot password?',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              vTinySpace,
                              CustomTextFormField(
                                onFieldSubmitted: (_) =>
                                    model.loginEmailPassword(
                                        email: model.email,
                                        password: model.password),
                                onChanged: model.setPassword,
                                password: true,
                              ),
                              vRegularSpace,
                              GenericButton(
                                onTap: () => model.loginEmailPassword(
                                    email: model.email,
                                    password: model.password),
                                title: 'Login',
                                positive: true,
                                stretch: true,
                              ),
                              const Expanded(child: SizedBox()),
                              const Center(
                                  child: Text('Don\'t have an account yet?')),
                              vSmallSpace,
                              GenericButton(
                                title: 'Sign up',
                                onTap: model.navigateToSignUpScreen,
                                invertColors: true,
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
