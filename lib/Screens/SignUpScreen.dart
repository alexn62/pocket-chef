import 'dart:io';

import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/Screens/BaseView.dart';
import 'package:personal_recipes/ViewModels/SignUpViewModel.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/CustomTextFormField.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/FullScreenLoadingIndicator.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/GenericButton.dart';

import '../Enums/Enum.dart';
import '../Widgets/AuthScreens/AppleGoogleButton.dart';

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
                        physics: const BouncingScrollPhysics(),
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
                                    Image.asset(
                                      'assets/icons/hug.png',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
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
                              const Expanded(
                                child: blankSpace,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextFormField(
                                    hintText: 'Email',
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .tertiary
                                        .withOpacity(.05),
                                    onChanged: model.setEmail,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  vSmallSpace,
                                  CustomTextFormField(
                                    hintText: 'Password',
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .tertiary
                                        .withOpacity(.05),
                                    onChanged: model.setPassword,
                                    password: true,
                                  ),
                                  vSmallSpace,
                                  CustomTextFormField(
                                    hintText: 'Confirm Password',
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .tertiary
                                        .withOpacity(.05),
                                    onChanged: model.setConfirmPassword,
                                    password: true,
                                  ),
                                  vSmallSpace,
                                ],
                              ),
                              vSmallSpace,
                              GenericButton(
                                positive: true,
                                rounded: true,
                                onTap: () => model.signUpEmailPassword(
                                    email: model.email,
                                    password: model.password,
                                    confirmPassword: model.confirmPassword),
                                title: 'Sign Up',
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppleGoogleButton(
                                      onTap: model.signUpWithGoogle,
                                      platform: AppleGoogle.Google),
                                  // hSmallSpace,
                                  // Expanded(
                                  //   child: AppleGoogleButton(
                                  //       onTap: () {},
                                  //       platform: AppleGoogle.Apple),
                                  // ),
                                ],
                              ),
                              const Expanded(child: blankSpace),
                              const Center(
                                  child: Text('Already have an account?')),
                              vSmallSpace,
                              GenericButton(
                                invertColors: true,
                                rounded: true,
                                title: 'Login',
                                onTap: model.navigateToLoginScreen,
                                stretch: true,
                              ),
                              Platform.isIOS ? vRegularSpace : blankSpace
                            ],
                          ),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     const Expanded(
                          //       child: blankSpace,
                          //     ),
                          //     Align(
                          //       alignment: Alignment.center,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.center,
                          //         mainAxisSize: MainAxisSize.min,
                          //         children: [
                          //           const Text(
                          //             'hi',
                          //             style: TextStyle(fontSize: 18),
                          //           ),
                          //           vRegularSpace,
                          //           Image.asset(
                          //             'assets/icons/hug.png',
                          //             color: Theme.of(context)
                          //                 .colorScheme
                          //                 .tertiary,
                          //             height: 64,
                          //           ),
                          //           vRegularSpace,
                          //           const Text(
                          //             'thanks for joining',
                          //             style: TextStyle(fontSize: 18),
                          //           ),
                          //           vSmallSpace,
                          //           const Text(
                          //             'please register to create your recipes',
                          //             style: TextStyle(fontSize: 18),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //     const Expanded(child: blankSpace),
                          //     Container(
                          //       padding: const EdgeInsets.all(15),
                          //       decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(35 / 2),
                          //           color: Theme.of(context)
                          //               .colorScheme
                          //               .tertiary
                          //               .withOpacity(.05)),
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           const Text(
                          //             ' Email',
                          //             style: TextStyle(
                          //               fontSize: 16,
                          //             ),
                          //           ),
                          //           vSmallSpace,
                          //           CustomTextFormField(
                          //             fillColor:
                          //                 Theme.of(context).backgroundColor,
                          //             onChanged: model.setEmail,
                          //             keyboardType: TextInputType.emailAddress,
                          //           ),
                          //           vRegularSpace,
                          //           Text(
                          //             ' Password',
                          //             style: TextStyle(
                          //               color: Theme.of(context).primaryColor,
                          //               fontSize: 16,
                          //             ),
                          //           ),
                          //           vSmallSpace,
                          //           CustomTextFormField(
                          //             fillColor:
                          //                 Theme.of(context).backgroundColor,
                          //             onChanged: model.setPassword,
                          //             password: true,
                          //           ),
                          //           vRegularSpace,
                          //           Text(
                          //             ' Confirm Password',
                          //             style: TextStyle(
                          //               color: Theme.of(context).primaryColor,
                          //               fontSize: 16,
                          //             ),
                          //           ),
                          //           vSmallSpace,
                          //           CustomTextFormField(
                          //             fillColor:
                          //                 Theme.of(context).backgroundColor,
                          //             onFieldSubmitted: (_) =>
                          //                 model.signUpEmailPassword(
                          //                     email: model.email,
                          //                     password: model.password,
                          //                     confirmPassword:
                          //                         model.confirmPassword),
                          //             onChanged: model.setConfirmPassword,
                          //             password: true,
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //     vRegularSpace,
                          //     GenericButton(
                          //       rounded: true,
                          //       onTap: () => model.signUpEmailPassword(
                          //           email: model.email,
                          //           password: model.password,
                          //           confirmPassword: model.confirmPassword),
                          //       title: 'Sign up',
                          //       positive: true,
                          //       stretch: true,
                          //     ),
                          //     vRegularSpace,
                          //     Align(
                          //       alignment: Alignment.center,
                          //       child: Text(
                          //         'Or continue with...',
                          //         style: TextStyle(
                          //           color: Theme.of(context).primaryColor,
                          //           fontSize: 15,
                          //         ),
                          //       ),
                          //     ),
                          //     vRegularSpace,
                          //     Row(
                          //       children: [
                          //         Expanded(
                          //           child: AppleGoogleButton(
                          //               onTap: () {},
                          //               platform: AppleGoogle.Google),
                          //         ),
                          //         hSmallSpace,
                          //         Expanded(
                          //           child: AppleGoogleButton(
                          //               onTap: () {},
                          //               platform: AppleGoogle.Apple),
                          //         ),
                          //       ],
                          //     ),
                          //     const Expanded(child: blankSpace),
                          //     const Center(
                          //         child: Text('Already have an account?')),
                          //     vSmallSpace,
                          //     GenericButton(
                          //       rounded: true,
                          //       invertColors: true,
                          //       title: 'Login',
                          //       onTap: model.navigateToLoginScreen,
                          //       stretch: true,
                          //     ),
                          //     vRegularSpace,
                          //   ],
                          // ),
                        ),
                      )),
                  FullScreenLoadingIndicator(model.loadingStatus),
                ],
              ),
            ));
  }
}
