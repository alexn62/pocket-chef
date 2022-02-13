import 'dart:io';

import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/ViewModels/ForgotPasswordViewModel.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/CustomTextFormField.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/FullScreenLoadingIndicator.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/GenericButton.dart';

import 'BaseView.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<ForgotPasswordViewModel>(
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
                                      'uh oh',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    vRegularSpace,
                                    Image.asset('assets/icons/secret.png',
                                        height: 64,
                                        color: Theme.of(context).errorColor),
                                    vRegularSpace,
                                    const Text(
                                      'hang in there',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    vSmallSpace,
                                    const Text(
                                      'please reset your password',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              const Expanded(
                                child: blankSpace,
                              ),
                              CustomTextFormField(
                                  hintText: 'Email',
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .tertiary
                                      .withOpacity(.05),
                                  onFieldSubmitted: (_) =>
                                      model.forgotPassword(model.email),
                                  onChanged: model.setEmail),
                              vRegularSpace,
                              GenericButton(
                                onTap: () => model.forgotPassword(model.email),
                                title: 'Send',
                                positive: true,
                                stretch: true,
                                rounded: true,
                              ),
                              const Expanded(child: blankSpace),
                              const Center(child: Text('Login instead?')),
                              vSmallSpace,
                              GenericButton(
                                rounded: true,
                                invertColors: true,
                                title: 'Login',
                                onTap: model.navigateToLoginScreen,
                                stretch: true,
                              ),
                              Platform.isIOS ? vRegularSpace : blankSpace
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
