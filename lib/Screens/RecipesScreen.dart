import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../Constants/Spacing.dart';
import '../Enums/Enum.dart';
import '../Services/GeneralServices.dart';
import '../ViewModels/RecipesViewModel.dart';
import '../Widgets/General Widgets/AddTagTextField.dart';
import '../Widgets/RecipesScreen/EmptyRecipesPlaceholder.dart';
import '../Widgets/RecipesScreen/RecipesListItem.dart';
import '../Widgets/RecipesScreen/RecipesScreenAppBar.dart';
import '../Widgets/RecipesScreen/SearchFiltersComponent.dart';
import 'BaseView.dart';

class RecipesScreen extends StatefulWidget {
  final bool reload;
  const RecipesScreen({Key? key, required this.reload}) : super(key: key);

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen>
    with
        AutomaticKeepAliveClientMixin<RecipesScreen>,
        TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  toggleContainer() {
    if (_animation!.status != AnimationStatus.completed) {
      _controller!.forward();
    } else {
      _controller!.animateBack(0, duration: const Duration(milliseconds: 200));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BaseView<RecipesViewModel>(
      onModelReady: (model) => model.initialize(model.currentUser.uid),
      builder: (context, model, child) {
        bool reload = Provider.of<GeneralServices>(context).newRecipeAdded;
        if (reload) {
          Provider.of<GeneralServices>(context, listen: false)
              .setNewRecipeAdded(false);
          SchedulerBinding.instance.addPostFrameCallback(
            (timeStamp) async {
              await model.initialize(model.currentUser.uid);
            },
          );
        }
        return Scaffold(
          body: Stack(
            children: [
              Scaffold(
                extendBodyBehindAppBar: true,
                backgroundColor: Theme.of(context).backgroundColor,
                appBar: RecipesAppBar(
                    deleteRecipes: model.deleteRecipes,
                    navigateToSettings: model.navigateToSettings,
                    recipes: model.recipes,
                    searchRecipes: model.searchRecipes,
                    toggleContainer: toggleContainer),
                body: Stack(
                  children: [
                    !Platform.isIOS
                        ? RefreshIndicator(
                            displacement: 40,
                            edgeOffset: MediaQuery.of(context).padding.top +
                                AppBar().preferredSize.height +
                                60,
                            onRefresh: () =>
                                model.getRecipesByUserId(model.currentUser.uid),
                            child: CustomScrollView(
                              physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              slivers: [
                                SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).padding.top +
                                        AppBar().preferredSize.height +
                                        60,
                                  ),
                                ),
                                SearchFiltersComponents(
                                  toggleAddTag: model.toggleAddTag,
                                  toggleTag: model.filterRecipes,
                                  tagList: model.filters,
                                  expandFilters: model.expandFilters,
                                  controller: _controller!,
                                  animation: _animation!,
                                ),
                                SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: model.recipes.isEmpty &&
                                          model.loadingStatus ==
                                              LoadingStatus.Idle
                                      ? const EmptyRecipesPlaceholder()
                                      : Column(
                                          children: model.foundRecipes != null
                                              ? [
                                                  ...model.foundRecipes!
                                                      .map(
                                                        (element) =>
                                                            RecipesListItem(
                                                                recipe:
                                                                    element),
                                                      )
                                                      .toList(),
                                                  Expanded(
                                                      child: GestureDetector(
                                                    onTap: () => FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus(),
                                                  ))
                                                ]
                                              : [
                                                  ...model.recipes
                                                      .map(
                                                        (element) =>
                                                            RecipesListItem(
                                                                recipe:
                                                                    element),
                                                      )
                                                      .toList(),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () => FocusManager
                                                          .instance.primaryFocus
                                                          ?.unfocus(),
                                                    ),
                                                  ),
                                                ],
                                        ),
                                ),
                              ],
                            ),
                          )
                        : CustomScrollView(
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            slivers: [
                              SliverPadding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).padding.top +
                                        AppBar().preferredSize.height +
                                        60),
                                sliver: CupertinoSliverRefreshControl(
                                  onRefresh: () => model.getRecipesByUserId(
                                      model.currentUser.uid),
                                ),
                              ),
                              SearchFiltersComponents(
                                toggleAddTag: model.toggleAddTag,
                                toggleTag: model.filterRecipes,
                                tagList: model.filters,
                                expandFilters: model.expandFilters,
                                controller: _controller!,
                                animation: _animation!,
                              ),
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: model.recipes.isEmpty &&
                                        model.loadingStatus ==
                                            LoadingStatus.Idle
                                    ? const EmptyRecipesPlaceholder()
                                    : Column(
                                        children: model.foundRecipes != null
                                            ? [
                                                ...model.foundRecipes!
                                                    .map(
                                                      (element) =>
                                                          RecipesListItem(
                                                              recipe: element),
                                                    )
                                                    .toList(),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () => FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus(),
                                                  ),
                                                ),
                                              ]
                                            : [
                                                ...model.recipes
                                                    .map(
                                                      (element) =>
                                                          RecipesListItem(
                                                              recipe: element),
                                                    )
                                                    .toList(),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () => FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus(),
                                                  ),
                                                ),
                                              ],
                                      ),
                              )
                            ],
                          ),
                  ],
                ),
              ),
              model.showAddTag
                  ? AddTagTextField(
                      toggleAddTag: model.toggleAddTag, addTag: model.addTag)
                  : blankSpace
            ],
          ),
        );
      },
    );
  }
}
