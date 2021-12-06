import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_recipes/Screens/AddRecipeScreen.dart';
import 'package:personal_recipes/Screens/RecipesScreen.dart';
import 'package:personal_recipes/Services/GeneralServices.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<GeneralServices>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: PageView(
        physics: const BouncingScrollPhysics(),
        controller: _pageController,
        children: const [RecipesScreen(), AddRecipeScreen()],
        onPageChanged: (val) {
          WidgetsBinding.instance!.focusManager.primaryFocus?.unfocus();
          model.setIndex(val);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).primaryColor.withOpacity(0.8),
        backgroundColor: Theme.of(context).backgroundColor,
        selectedLabelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
        currentIndex: model.index,
        onTap: (val) {
          WidgetsBinding.instance!.focusManager.primaryFocus?.unfocus();
          _pageController.animateToPage(val,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut);
        },
        items: [
          BottomNavigationBarItem(
            label: 'Recipes',
            tooltip: '',
            icon: Center(
              child: Icon(
                  Platform.isIOS ? CupertinoIcons.book : Icons.menu_book,
                  color: model.index == 0
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColor.withOpacity(0.8),
                  size: model.index == 0 ? 24 : 18),
            ),
          ),
          BottomNavigationBarItem(
            label: 'Add Recipe',
            tooltip: '',
            icon: Icon(Platform.isIOS ? CupertinoIcons.add : Icons.add_sharp,
                color: model.index == 1
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).primaryColor.withOpacity(0.8),
                size: model.index == 1 ? 24 : 18),
          ),
        ],
      ),
    );
  }
}
