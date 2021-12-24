import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:personal_recipes/Enums/Enum.dart';
import 'package:personal_recipes/Services/GeneralServices.dart';
import 'package:personal_recipes/ViewModels/RecipesViewModel.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/AddTagTextField.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/CustomTextFormField.dart';
import 'package:personal_recipes/Widgets/RecipesScreen/EmptyRecipesPlaceholder.dart';
import 'package:personal_recipes/Widgets/RecipesScreen/RecipesListItem.dart';
import 'package:personal_recipes/Widgets/RecipesScreen/SearchFiltersComponent.dart';
import 'package:provider/provider.dart';
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
  bool expandFilters = false;
  void setExpandFilters() {
    setState(() {
      expandFilters = !expandFilters;
    });
  }

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

  _toggleContainer() {
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
            SchedulerBinding.instance!.addPostFrameCallback((timeStamp) async {
              await model.initialize(model.currentUser.uid);
            });
          }
          return Scaffold(
            body: Stack(
              children: [
                Scaffold(
                    extendBodyBehindAppBar: true,
                    backgroundColor: Theme.of(context).backgroundColor,
                    appBar: AppBar(
                      flexibleSpace: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: -10),
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
                          : null,
                      title: const Text(
                        'Recipes',
                      ),
                      actions: [
                        IconButton(
                          onPressed: model.navigateToSettings,
                          icon: Icon(
                            Platform.isIOS
                                ? CupertinoIcons.settings
                                : Icons.settings,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                      bottom: PreferredSize(
                          preferredSize: const Size(double.infinity, 60),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5, bottom: 5, right: 0, left: 15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomTextFormField(
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .tertiary
                                        .withOpacity(0.05),
                                    hintText: 'Search',
                                    prefixIcon: Icon(
                                        Platform.isIOS
                                            ? CupertinoIcons.search
                                            : Icons.search,
                                        color: Theme.of(context).primaryColor),
                                    onChanged: model.searchRecipes,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _toggleContainer,
                                  icon: Icon(Platform.isIOS
                                      ? CupertinoIcons.slider_horizontal_3
                                      : Icons.filter_alt_outlined),
                                  padding: EdgeInsets.zero,
                                )
                              ],
                            ),
                          )),
                    ),
                    body: Stack(
                      children: [
                        !Platform.isIOS
                            ? RefreshIndicator(
                                displacement: 40,
                                edgeOffset: MediaQuery.of(context).padding.top +
                                    AppBar().preferredSize.height +
                                    60,
                                onRefresh: () => model
                                    .getRecipesByUserId(model.currentUser.uid),
                                child: CustomScrollView(
                                  physics: const BouncingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics()),
                                  slivers: [
                                    SliverToBoxAdapter(
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).padding.top +
                                                AppBar().preferredSize.height +
                                                60,
                                      ),
                                    ),
                                    SearchFiltersComponents(
                                      toggleAddTag: model.toggleAddTag,
                                      toggleTag: model.filterRecipes,
                                      tagList: model.filters,
                                      expandFilters: expandFilters,
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
                                              children:
                                                  model.foundRecipes != null
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
                                                              child:
                                                                  GestureDetector(
                                                            onTap: () =>
                                                                FocusManager
                                                                    .instance
                                                                    .primaryFocus
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
                                                              child:
                                                                  GestureDetector(
                                                            onTap: () =>
                                                                FocusManager
                                                                    .instance
                                                                    .primaryFocus
                                                                    ?.unfocus(),
                                                          ))
                                                        ]),
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
                                        top:
                                            MediaQuery.of(context).padding.top +
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
                                    expandFilters: expandFilters,
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
                                                    ))
                                                  ]),
                                  )
                                ],
                              ),
                      ],
                    )),
                model.showAddTag
                    ? AddTagTextField(
                        toggleAddTag: model.toggleAddTag, addTag: model.addTag)
                    : const SizedBox()
              ],
            ),
          );
        });
  }
}
