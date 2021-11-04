import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/ViewModels/ForgotPasswordViewModel.dart';
import 'package:personal_recipes/widgets/CustomTextFormField.dart';
import 'package:personal_recipes/widgets/GenericButton.dart';

import 'BaseView.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<ForgotPasswordViewModel>(
        builder: (context, model, child) => WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: Theme.of(context).backgroundColor,
                  body: Center(
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          vBigSpace,
                          vBigSpace,
                          vBigSpace,
                          Text(
                            'Email',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                            ),
                          ),
                          vTinySpace,
                          CustomTextFormField(onChanged: model.setEmail),
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
                            invertColors: true,
                            stretch: true,
                          ),
                          vRegularSpace,
                        ],
                      ),
                    ),
                  )),
            ));
  }
}
