import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/Constants/Themes.dart';
import 'package:personal_recipes/Models/Recipe.dart';
import 'package:personal_recipes/Screens/BaseView.dart';
import 'package:personal_recipes/Services/AdService.dart';
import 'package:personal_recipes/Services/GeneralServices.dart';
import 'package:personal_recipes/ViewModels/AddRecipeViewModel.dart';
import 'package:personal_recipes/Widgets/AddRecipeScreen/AddSectionComponent.dart';
import 'package:personal_recipes/Widgets/AddRecipeScreen/AddAdvancedComponent.dart';
import 'package:personal_recipes/Widgets/AddRecipeScreen/AddPhotoComponent.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/AddTagTextField.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/CustomTextFormField.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/FullScreenLoadingIndicator.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';

import '../locator.dart';

class AddRecipeScreen extends StatefulWidget {
  final Recipe? recipe;
  const AddRecipeScreen({Key? key, this.recipe}) : super(key: key);

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen>
    with AutomaticKeepAliveClientMixin<AddRecipeScreen> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _servesController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  late GlobalKey<FormState> _formKey;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    locator<AdService>().createInterstitialAd();

    super.initState();
  }

  void _jumpToTop() {
    _controller.jumpTo(
      0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    locator<AdService>().interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _jumpToTop();
    });
    super.build(context);
    final GeneralServices _generalServices =
        Provider.of<GeneralServices>(context);

    return BaseView<AddRecipeViewModel>(
      onModelReady: (model) => model.initialize(recipe: widget.recipe),
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          DialogResponse<dynamic>? response = await locator<DialogService>()
              .showDialog(
                  title: 'Warning',
                  description:
                      'Are you sure you want to dismiss your changes and go back?',
                  barrierDismissible: true,
                  cancelTitle: 'Cancel');
          if (response == null || !response.confirmed) {
            return false;
          } else {
            locator<NavigationService>().back(
                result: Provider.of<AddRecipeViewModel>(context, listen: false)
                    .recipe
                    .photoUrl);
            return true;
          }
        },
        child: Stack(
          children: [
            GestureDetector(
              onHorizontalDragUpdate: widget.recipe == null
                  ? null
                  : (details) async {
                      int sensitivity = 10;
                      if (details.delta.dx > sensitivity) {
                        DialogResponse<dynamic>? response =
                            await locator<DialogService>().showDialog(
                                title: 'Warning',
                                description:
                                    'Are you sure you want to dismiss your changes and go back?',
                                barrierDismissible: true,
                                cancelTitle: 'Cancel');
                        if (response == null || !response.confirmed) {
                          return;
                        } else {
                          locator<NavigationService>()
                              .back(result: model.recipe.photoUrl);
                          return;
                        }
                      }
                    },
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                extendBodyBehindAppBar: true,
                backgroundColor: Theme.of(context).backgroundColor,
                appBar: AppBar(
                  elevation: 0,
                  flexibleSpace: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  automaticallyImplyLeading: widget.recipe != null,
                  backgroundColor:
                      Theme.of(context).backgroundColor.withOpacity(2 / 3),
                  title: Text(
                    widget.recipe == null ? 'Add Recipe' : 'Edit recipe',
                  ),
                  actions: [
                    IconButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            late bool result;
                            if (widget.recipe == null) {
                              result = await model.addRecipe(
                                model.recipe,
                                model.img,
                              );
                              _titleController.text = '';
                              _servesController.text = '';
                              _instructionsController.text = '';
                              Provider.of<GeneralServices>(context,
                                      listen: false)
                                  .setNewRecipeAdded(true);
                            } else {
                              result = await model.updateRecipe(
                                  model.recipe, model.img);
                            }
                            if (result && _generalServices.timer == null ||
                                _generalServices.timer != null &&
                                    !_generalServices.timer!.isActive) {
                              _generalServices.setTimer();
                              locator<AdService>().showInterstitialAd();
                            }
                          }
                        },
                        icon: Icon(
                          Platform.isIOS
                              ? CupertinoIcons.check_mark
                              : Icons.check,
                          color: goodColor,
                        ))
                  ],
                ),
                body: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.only(
                        top: 10,
                        right: 15,
                        left: 15,
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        controller: _controller,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: MediaQuery.of(context).padding.top +
                                      AppBar().preferredSize.height),
                              AddPhotoComponent(
                                status: model.photoLoadingStatus,
                                currentImage: model.recipe.photoUrl,
                                img: model.img,
                                deleteImage: () => model.deleteImage(
                                    tempImage: model.img, recipe: model.recipe),
                                getImage: model.getImage,
                              ),
                              vSmallSpace,
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'Title',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                    hSmallSpace,
                                    Flexible(
                                      flex: 1,
                                      child: Text(
                                        'Serves',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary
                                        .withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: CustomTextFormField(
                                        controller: widget.recipe == null
                                            ? _titleController
                                            : null,
                                        hintText: 'e.g., Pizza',
                                        initialValue: widget.recipe != null
                                            ? model.recipe.title
                                            : null,
                                        validator: (text) {
                                          if (text == null ||
                                              text.trim().isEmpty) {
                                            return 'Please enter a recipe title.';
                                          }
                                          if (text.length < 2 ||
                                              text.length > 20) {
                                            return 'The text has to be between two and twenty characters.';
                                          }
                                          return null;
                                        },
                                        onChanged: model.setRecipeTitle,
                                      ),
                                    ),
                                    hSmallSpace,
                                    Flexible(
                                      flex: 1,
                                      child: CustomTextFormField(
                                        controller: widget.recipe == null
                                            ? _servesController
                                            : null,
                                        hintText: 'e.g., 4',
                                        initialValue: widget.recipe != null
                                            ? model.recipe.serves?.toString()
                                            : null,
                                        validator: (text) {
                                          if (text == null ||
                                              text.trim().isEmpty ||
                                              text.trim().length > 5 ||
                                              double.tryParse(text) == null) {
                                            return 'Err';
                                          }
                                          return null;
                                        },
                                        onChanged: model.setServesNumber,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              vSmallSpace,
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Sections',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 17)),
                                    SizedBox(
                                      height: 30,
                                      child: IconButton(
                                          onPressed: () {
                                            model.addSection();
                                          },
                                          padding: const EdgeInsets.all(0),
                                          icon: Icon(
                                            Platform.isIOS
                                                ? CupertinoIcons.add
                                                : Icons.add,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  ...model.recipe.sections
                                      .asMap()
                                      .entries
                                      .map(
                                        (entry) => AddSectionComponent(
                                          setSectionTitle:
                                              model.setSectionTitle,
                                          removeSection: () =>
                                              model.removeSection(entry.key),
                                          title: entry.value.title,
                                          sectionIndex: entry.key,
                                          ingredients: model.recipe
                                              .sections[entry.key].ingredients,
                                          key: ValueKey(entry.value.uid),
                                        ),
                                      )
                                      .toList(),
                                ],
                              ),
                              vTinySpace,
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 0),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary
                                        .withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(15)),
                                child: ListTileTheme(
                                  dense: true,
                                  child: ExpansionTile(
                                    tilePadding:
                                        const EdgeInsets.only(right: 12),
                                    title: const Text('Instructions',
                                        style: TextStyle(fontSize: 17)),
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        child: CustomTextFormField(
                                          controller: widget.recipe == null
                                              ? _instructionsController
                                              : null,
                                          keyboardType: TextInputType.multiline,
                                          minLines: 3,
                                          maxLines: null,
                                          initialValue: widget.recipe != null
                                              ? model.recipe.instructions
                                              : null,
                                          validator: (text) {
                                            if (text == null) {
                                              return 'Value cannot be null';
                                            }
                                            if (text.length > 2000) {
                                              return 'The instructions must not be longer than 2000 characters.';
                                            }
                                            return null;
                                          },
                                          onChanged: model.setInstructions,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              vSmallSpace,
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 15),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary
                                        .withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(15)),
                                child: AddAdvancedComponent(
                                  deleteTag: model.deleteTag,
                                  toggleAddTag: model.toggleAddTag,
                                  tags: model.recipe.tags,
                                  toggleTag: model.setTagStatus,
                                ),
                              ),
                              const SafeArea(child: SizedBox())
                            ],
                          ),
                        ),
                      ),
                    ),
                    model.showAddTag
                        ? AddTagTextField(
                            toggleAddTag: model.toggleAddTag,
                            addTag: model.addTag,
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
            FullScreenLoadingIndicator(model.loadingStatus)
          ],
        ),
      ),
    );
  }
}
