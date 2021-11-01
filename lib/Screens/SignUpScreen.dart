import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/Screens/BaseView.dart';
import 'package:personal_recipes/ViewModels/SignUpViewModel.dart';
import 'package:personal_recipes/Widgets/CustomTextFormField.dart';
import 'package:personal_recipes/Widgets/GenericButton.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SignUpViewModel>(
        builder: (context, model, child) => WillPopScope(onWillPop: ()async=>false,
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
                      const Expanded(child: SizedBox(),),
                      Text(
                        'Email',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                        ),
                      ),
                      vSmallSpace,
                      CustomTextFormField(onChanged: model.setEmail, keyboardType: TextInputType.emailAddress,),
                      vSmallSpace,
                      Text(
                        'Password',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                        ),
                      ),
                      vSmallSpace,
                      CustomTextFormField(onChanged: model.setPassword, password: true,),
                      vSmallSpace,
                      Text(
                        'Confirm Password',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                        ),
                      ),
                      vSmallSpace,
                      CustomTextFormField(onChanged: model.setConfirmPassword, password: true,),
                      vRegularSpace,
                      GenericButton(
                        
                        onTap: () => model.signUpEmailPassword(email: model.email, password: model.password, confirmPassword: model.confirmPassword),
                        title: 'Sign up',
                        positive: true,
                        stretch: true,
                      ),
                      const Expanded(child: SizedBox()),
                      const Center(child:  Text('Already have an account?')),
                      vSmallSpace,
                      GenericButton(title: 'Login', onTap: model.navigateToLoginScreen,invertColors: true, stretch: true,),
                      vRegularSpace,
                    ],
                  ),
                ),
              )),
        ));
  }
}
