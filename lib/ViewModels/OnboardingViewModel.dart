import 'package:personal_recipes/Services/GeneralServices.dart';
import 'package:personal_recipes/ViewModels/BaseViewModel.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:personal_recipes/Constants/Routes.dart' as routes;

import '../locator.dart';

class OnboardingViewmodel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final GeneralServices _generalService = locator<GeneralServices>();

  int _index = 0;
  int get index => _index;
  void increaseIndex() {
    _index++;
    notifyListeners();
  }

  void doneWithOnboarding() {
    _generalService.setShowOnboarding(false);
  }

  final List<Map<String, dynamic>> pages = [
    {
      'image': 'assets/icons/pocket_chef_logo.png',
      'title': 'Welcome!',
      'description':
          'Take this short tour to find out about the exciting features of Pocket Chef!'
    },
    {
      'image': 'assets/images/screen1.png',
      'title': 'Recipe Overview',
      'description':
          'All of your recipes - nicely organized! \nSearch, filter, and favorite recipes to your liking.'
    },
    {
      'image': 'assets/images/screen2.png',
      'title': 'Detailed View',
      'description':
          'See all ingredients and instructions. \nMake use of the servings multiplier to quickly adjust ingredient amounts, without going through complicated calculations.'
    },
    {
      'image': 'assets/images/screen3.png',
      'title': 'Cooking Mode',
      'description':
          'Enable cooking mode while in the kitchen! Enjoy bigger buttons, bigger text, and easy controls.'
    },
    {
      'image': 'assets/images/screen4.png',
      'title': 'Add and Edit Recipes',
      'description':
          'Add a beautiful image, sections, ingredients, and step-by-step instructions.'
    },
  ];

  void navigateToSignUp() {
    _navigationService.replaceWith(
      routes.LandingPageRoute,
    );
  }
}
