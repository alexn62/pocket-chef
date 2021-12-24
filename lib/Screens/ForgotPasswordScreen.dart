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
                                child: SizedBox(),
                              ),
                              Text(
                                'Email',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16,
                                ),
                              ),
                              vTinySpace,
                              CustomTextFormField(
                                  fillColor: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.05),
                                  onFieldSubmitted: (_) =>
                                      model.forgotPassword(model.email),
                                  onChanged: model.setEmail),
                              vRegularSpace,
                              GenericButton(
                                onTap: () => model.forgotPassword(model.email),
                                title: 'Send',
                                positive: true,
                                stretch: true,
                              ),
                              const Expanded(child: SizedBox()),
                              const Center(child: Text('Login instead?')),
                              vSmallSpace,
                              GenericButton(
                                title: 'Login',
                                onTap: model.navigateToLoginScreen,
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
