import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/Constants/Themes.dart';
import 'package:personal_recipes/Enums/Enum.dart';

class AppleGoogleButton extends StatelessWidget {
  final Function onTap;
  final AppleGoogle platform;
  const AppleGoogleButton({
    Key? key,
    required this.onTap,
    required this.platform,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 35,
        decoration: BoxDecoration(
            color: platform == AppleGoogle.Apple ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: backgroundColorDark)),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              platform == AppleGoogle.Apple
                  ? 'assets/images/apple-white.png'
                  : 'assets/images/g-logo.png',
              width: platform == AppleGoogle.Apple ? 13 : 15,
            ),
            hSmallSpace,
            Text(
              platform == AppleGoogle.Apple ? 'Apple' : 'Google',
              style: TextStyle(
                  fontSize: 15,
                  color: platform == AppleGoogle.Apple
                      ? Colors.white
                      : const Color.fromRGBO(0, 0, 0, .54)),
            ),
          ],
        )),
      ),
    );
  }
}
