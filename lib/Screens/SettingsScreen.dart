import 'package:flutter/material.dart';
import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Services/GeneralServices.dart';
import 'package:personal_recipes/ViewModels/SettingsVIewModel.dart';
import 'package:personal_recipes/Widgets/GenericButton.dart';
import 'package:provider/provider.dart';

import 'BaseView.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GeneralServices _generalServices = Provider.of<GeneralServices>(context);
    return BaseView<SettingsViewModel>(builder: (context, model, child) {
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          title: const Text(
            'Settings',
          ),
          bottom: PreferredSize(
              child: Container(
                color: Theme.of(context).primaryColor,
                height: 1.0,
              ),
              preferredSize: const Size.fromHeight(1.0)),
        ),
        body: model.loadingStatus != LoadingStatus.Idle
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : ListView(
                children: [
                  ListTile(
                      title: const Text('Dark mode'),
                      trailing: Switch.adaptive(
                        onChanged: (value) async {
                          await _generalServices.setDarkMode(value);
                        },
                        value: _generalServices.darkMode!,
                      )),
                  GenericButton(
                    stretch: true,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                  onTap: model.logout,
                  title: 'Logout',
                  danger: true,
                    ),
                  
                ],
              ),
      );
    });
  }
}
