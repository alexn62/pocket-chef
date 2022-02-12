import 'dart:ui';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/Services/GeneralServices.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/FullScreenLoadingIndicator.dart';
import 'package:provider/provider.dart';
import '../ViewModels/SettingsVIewModel.dart';
import 'BaseView.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GeneralServices _generalServices =
        Provider.of<GeneralServices>(context);
    return BaseView<SettingsViewModel>(
        onModelReady: (model) => model.initialize(),
        builder: (context, model, child) {
          return Stack(
            children: [
              Scaffold(
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
                  backgroundColor:
                      Theme.of(context).backgroundColor.withOpacity(2 / 3),
                  title: const Text(
                    'Settings',
                  ),
                ),
                body: SafeArea(
                  top: false,
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          children: [
                            const SafeArea(
                              child: blankSpace,
                            ),
                            SettingsComponent(
                                title: 'General Settings',
                                items: [
                                  ListTile(
                                      title: const Text('Dark mode'),
                                      trailing: Switch.adaptive(
                                        onChanged: (value) async {
                                          await _generalServices
                                              .setDarkMode(value);
                                        },
                                        value: _generalServices.darkMode!,
                                      )),
                                ]),
                            SettingsComponent(title: 'Account', items: [
                              // const ListTile(
                              //   title: Text('Membership'),
                              //   trailing: Text('Standard'),
                              // ),
                              model.currentUser != null &&
                                      model.currentUser!.email != null
                                  ? ListTile(
                                      title: const Text('Email'),
                                      trailing: Text(model.currentUser!.email!))
                                  : null,
                              ListTile(
                                title: const Text('Change Password'),
                                trailing:
                                    const Icon(Icons.keyboard_arrow_right),
                                onTap: model.currentUser != null &&
                                        model.currentUser!.email != null
                                    ? () => model.resetPassword(
                                        model.currentUser!.email!)
                                    : () {},
                              ),
                              model.currentUser != null &&
                                      model.currentUser!.metadata
                                              .creationTime !=
                                          null
                                  ? ListTile(
                                      title: const Text('Member since'),
                                      trailing: Text(intl.DateFormat.yMMMMd()
                                          .format(model.currentUser!.metadata
                                              .creationTime!)),
                                    )
                                  : null,
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
                            SettingsComponent(title: 'About', items: [
                              ListTile(
                                title: const Text('Version'),
                                trailing: Text(model.versionNumber ?? ''),
                              ),
                            ]),
                            SettingsComponent(title: 'Danger zone', items: [
                              ListTile(
                                title: Text(
                                  'Delete Account',
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error),
                                ),
                                trailing: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Theme.of(context).errorColor,
                                ),
                                onTap: model.deleteUser,
                              ),
                            ]),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              FullScreenLoadingIndicator(model.loadingStatus)
            ],
          );
        });
  }
}

class SettingsComponent extends StatelessWidget {
  final String? title;
  final List<ListTile?> items;
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
                  color:
                      Theme.of(context).colorScheme.tertiary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                  children: items
                      .map((item) => item != null
                          ? Column(
                              children: [
                                item,
                                item != items.last
                                    ? Divider(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary
                                            .withOpacity(0.3),
                                        height: 0,
                                        thickness: 0,
                                      )
                                    : blankSpace
                              ],
                            )
                          : blankSpace)
                      .toList())),
        ],
      ),
    );
  }
}
