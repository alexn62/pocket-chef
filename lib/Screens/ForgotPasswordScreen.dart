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
                          Text(
                            'Email',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                            ),
                          ),
                          vSmallSpace,
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
