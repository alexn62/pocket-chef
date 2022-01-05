import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Themes.dart';
import 'package:stacked_services/stacked_services.dart';

import '../locator.dart';

enum SnackbarType { undo }

void setupSnackbarUi() {
  final service = locator<SnackbarService>();

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.undo,
    config: SnackbarConfig(

        backgroundColor: Colors.white,
        messageColor: accentColor,
        mainButtonTextColor: accentColor,
        textColor: Colors.yellow,
        borderRadius: 15,
        boxShadows: const [BoxShadow(blurRadius: 15, spreadRadius: 5, color: Colors.black12)],
        margin: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        
        
        ),
  );
}
