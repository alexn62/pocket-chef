import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/Constants/Themes.dart';
import 'package:personal_recipes/ViewModels/OnboardingViewModel.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/GenericButton.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'BaseView.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller =
      PageController(viewportFraction: 1, keepPage: true, initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return BaseView<OnboardingViewmodel>(
      builder: (context, model, child) => Scaffold(
        backgroundColor: secondaryColor,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller,
                  itemBuilder: (_, __) {
                    return Scaffold(
                      backgroundColor: secondaryColor,
                      body: model.index == 0
                          ? Center(
                              child: Container(
                                  margin: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              (1 / 4)),
                                  height: MediaQuery.of(context).size.height *
                                      (1 / 3),
                                  width: MediaQuery.of(context).size.height *
                                      (1 / 3),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: AssetImage(
                                      model.pages[model.index]['image'],
                                    ),
                                  )),
                            )
                          : Center(
                              child: Container(
                                height: MediaQuery.of(context).size.height *
                                    (4 / 5),
                                color: secondaryColor,
                                child: Image.asset(
                                    model.pages[model.index]['image'],
                                    fit: BoxFit.fill),
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * (1 / 3),
                decoration: const BoxDecoration(
                    color: tertiaryColor,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 15,
                          blurRadius: 15)
                    ]),
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.pages[model.index]['title'],
                            style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: accentColor),
                          ),
                          vRegularSpace,
                          Text(
                            model.pages[model.index]['description'],
                            style: const TextStyle(
                                fontSize: 17, color: accentColor),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: SmoothPageIndicator(
                              controller: controller,
                              count: model.pages.length,
                              effect: const ExpandingDotsEffect(
                                  dotHeight: 16,
                                  dotWidth: 16,
                                  dotColor: accentColor,
                                  activeDotColor: accentColor),
                            ),
                          ),
                        ),
                        const Expanded(child: blankSpace),
                        Flexible(
                          flex: 2,
                          child: GenericButton(
                            height: 45,
                            fontsize: 17,
                            color: accentColor,
                            textColor: Colors.white,
                            shrink: model.index == model.pages.length - 1,
                            onTap: () {
                              if (model.index < model.pages.length - 1) {
                                model.increaseIndex();
                                controller.animateToPage(model.index,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut);
                              } else {
                                model.doneWithOnboarding();
                                model.navigateToSignUp();
                              }
                            },
                            title: model.index != model.pages.length - 1
                                ? model.index == 0
                                    ? 'Let\'s Go!'
                                    : 'Next'
                                : 'Get Started',
                            rounded: true,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
