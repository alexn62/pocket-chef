import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Services/GeneralServices.dart';
import 'package:personal_recipes/ViewModels/SettingsViewModel.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/GenericButton.dart';
import 'package:provider/provider.dart';

import 'BaseView.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GeneralServices _generalServices =
        Provider.of<GeneralServices>(context);
    return BaseView<SettingsViewModel>(builder: (context, model, child) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          backgroundColor: Theme.of(context).backgroundColor.withOpacity(2 / 3),
          title: const Text(
            'Settings',
          ),
        ),
        body: model.loadingStatus != LoadingStatus.Idle
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).padding.top +
                                AppBar().preferredSize.height),
                        ListTile(
                            title: const Text('Dark mode'),
                            trailing: Switch.adaptive(
                              onChanged: (value) async {
                                await _generalServices.setDarkMode(value);
                              },
                              value: _generalServices.darkMode!,
                            )),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        GenericButton(
                          stretch: true,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          onTap: model.logout,
                          title: 'Logout',
                          danger: true,
                        ),
                        vBigSpace,
                      ],
                    ),
                  )
                ],
              ),
      );
    });
  }
}
