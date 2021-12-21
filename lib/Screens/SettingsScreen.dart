import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Services/GeneralServices.dart';
import 'package:personal_recipes/ViewModels/SettingsViewModel.dart';
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
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
        body: SafeArea(
          top: false,
          child: model.loadingStatus != LoadingStatus.Idle
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        children: [
                          const SafeArea(
                            child: SizedBox(),
                          ),
                          SettingsComponent(title: 'General Settings', items: [
                            ListTile(
                                title: const Text('Dark mode'),
                                trailing: Switch.adaptive(
                                  onChanged: (value) async {
                                    await _generalServices.setDarkMode(value);
                                  },
                                  value: _generalServices.darkMode!,
                                )),
                          ]),
                          SettingsComponent(title: 'Account', items: [
                            const ListTile(
                              title: Text('Membership'),
                              trailing: Text('Standard'),
                            ),
                            const ListTile(
                              title: Text('Email'),
                              trailing: Text('alex.nssbmr@gmail.com'),
                            ),
                            const ListTile(
                              title: Text('Change Password'),
                              trailing: Icon(Icons.keyboard_arrow_right),
                            ),
                            const ListTile(
                              title: Text('Member since'),
                              trailing: Text('01 December, 2021'),
                            ),
                            ListTile(
                              title: const Text(
                                'Logout',
                              ),
                              trailing: const Icon(
                                Icons.keyboard_arrow_right,
                              ),
                              onTap: model.logout,
                            ),
                          ]),
                          const SettingsComponent(title: 'About', items: [
                            ListTile(
                              title: Text('Version'),
                              trailing: Text('1.1.0'),
                            ),
                          ]),
                          SettingsComponent(title: 'Danger zone', items: [
                            ListTile(
                              title: Text(
                                'Delete Account',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.error),
                              ),
                              trailing: Icon(
                                Icons.keyboard_arrow_right,
                                color: Theme.of(context).errorColor,
                              ),
                              onTap: () {},
                            ),
                          ]),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      );
    });
  }
}

class SettingsComponent extends StatelessWidget {
  final String? title;
  final List<ListTile> items;
  const SettingsComponent({
    this.title,
    required this.items,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title == null
              ? const SizedBox.shrink()
              : Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
          vRegularSpace,
          Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                  children: items
                      .map((item) => Column(
                            children: [
                              item,
                              item != items.last
                                  ? Divider(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.3),
                                      height: 0,
                                      thickness: 0,
                                    )
                                  : const SizedBox()
                            ],
                          ))
                      .toList())),
        ],
      ),
    );
  }
}
