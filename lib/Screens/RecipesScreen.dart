import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/ViewModels/RecipesViewModel.dart';
import 'package:personal_recipes/Widgets/EmptyRecipesPlaceholder.dart';
import 'package:personal_recipes/Widgets/RecipesListItem.dart';
import 'BaseView.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen>
    with AutomaticKeepAliveClientMixin<RecipesScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BaseView<RecipesViewModel>(
        onModelReady: (model) => model.initialize(model.currentUser.uid),
        builder: (context, model, child) {
          return Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBar(
                flexibleSpace: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 7, sigmaY: -7),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                backgroundColor:
                    Theme.of(context).backgroundColor.withOpacity(2 / 3),
                automaticallyImplyLeading: false,
                leading: model.recipes
                        .where((element) => element.selected!)
                        .isNotEmpty
                    ? IconButton(
                        onPressed: () => model.deleteRecipes(model.recipes
                            .where((element) => element.selected!)),
                        icon: Icon(Platform.isIOS
                            ? CupertinoIcons.delete
                            : Icons.delete_outline))
                    : const SizedBox(),
                title: const Text(
                  'Recipes',
                ),
                actions: [
                  // IconButton(
                  //   onPressed: model.navigateToSettings,
                  //   icon: Icon(
                  //     Platform.isIOS ? CupertinoIcons. : Icons.settings,
                  //     color: Theme.of(context).primaryColor,
                  //   ),
                  // ),
                  IconButton(
                    onPressed: model.navigateToSettings,
                    icon: Icon(
                      Platform.isIOS ? CupertinoIcons.settings : Icons.settings,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              body: !Platform.isIOS
                  ? RefreshIndicator(
                      displacement: 40,
                      edgeOffset: MediaQuery.of(context).padding.top +
                          AppBar().preferredSize.height,
                      onRefresh: () =>
                          model.getRecipesByUserId(model.currentUser.uid),
                      child: CustomScrollView(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        slivers: [
                          SliverToBoxAdapter(
                              child: SizedBox(
                            height: MediaQuery.of(context).padding.top +
                                AppBar().preferredSize.height,
                          )),
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: model.recipes.isEmpty &&
                                    model.loadingStatus == LoadingStatus.Idle
                                ? const EmptyRecipesPlaceholder()
                                : Column(
                                    children: model.recipes
                                        .map(
                                          (element) =>
                                              RecipesListItem(element: element),
                                        )
                                        .toList(),
                                  ),
                          )
                        ],
                      ))
                  : CustomScrollView(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top +
                                  AppBar().preferredSize.height),
                          sliver: CupertinoSliverRefreshControl(
                            onRefresh: () =>
                                model.getRecipesByUserId(model.currentUser.uid),
                          ),
                        ),
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: model.recipes.isEmpty &&
                                  model.loadingStatus == LoadingStatus.Idle
                              ? const EmptyRecipesPlaceholder()
                              : Column(
                                  children: model.recipes
                                      .map(
                                        (element) =>
                                            RecipesListItem(element: element),
                                      )
                                      .toList(),
                                ),
                        )
                      ],
                    ));
        });
  }
}
