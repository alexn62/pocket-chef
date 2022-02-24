import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:personal_recipes/Enums/Enum.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';

import '../Constants/Spacing.dart';
import '../Models/Recipe.dart';
import '../Services/AdService.dart';
import '../Services/GeneralServices.dart';
import '../ViewModels/AddRecipeViewModel.dart';
import '../Widgets/AddRecipeScreen/AddAdvancedComponent.dart';
import '../Widgets/AddRecipeScreen/AddInstructionsComponent.dart';
import '../Widgets/AddRecipeScreen/AddPhotoComponent.dart';
import '../Widgets/AddRecipeScreen/AddRecipeAppBar.dart';
import '../Widgets/AddRecipeScreen/AddSectionsComponent.dart';
import '../Widgets/AddRecipeScreen/AddTitleComponent.dart';
import '../Widgets/General Widgets/AddTagTextField.dart';
import '../Widgets/General Widgets/FullScreenLoadingIndicator.dart';
import '../locator.dart';
import 'BaseView.dart';

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
  late GlobalKey<FormState> _formKey;
  Recipe? oldRecipe;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    locator<AdService>().createInterstitialAd();
    oldRecipe =
        widget.recipe == null ? null : Recipe.fromJson(widget.recipe!.toJson());
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
        onWillPop: model.photoLoadingStatus == LoadingStatus.Busy
            ? () async {
                return false;
              }
            : () async {
                DialogResponse<dynamic>? response =
                    await locator<DialogService>().showDialog(
                        title: 'Warning',
                        description:
                            'Are you sure you want to dismiss your changes and go back?',
                        barrierDismissible: true,
                        cancelTitle: 'Cancel');
                if (response == null || !response.confirmed) {
                  return false;
                } else {
                  locator<NavigationService>().back(result: oldRecipe);

                  return true;
                }
              },
        child: Stack(
          children: [
            GestureDetector(
              onHorizontalDragUpdate: widget.recipe == null ||
                      model.photoLoadingStatus == LoadingStatus.Busy
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
                          locator<NavigationService>().back(result: oldRecipe);

                          return;
                        }
                      }
                    },
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                extendBodyBehindAppBar: true,
                backgroundColor: Theme.of(context).backgroundColor,
                appBar: AddRecipeAppBar(
                  title: widget.recipe == null ? 'Add Recipe' : 'Edit Recipe',
                  onAdd: () async {
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();

                      late bool result;
                      if (widget.recipe == null) {
                        result = await model.addRecipe(
                          model.recipe,
                          model.img,
                        );
                        _titleController.text = '';
                        _servesController.text = '';
                        Provider.of<GeneralServices>(context, listen: false)
                            .setNewRecipeAdded(true);
                      } else {
                        result = await model.updateRecipe(
                            recipe: model.recipe, image: model.img);
                      }
                      if (result && _generalServices.timer == null ||
                          _generalServices.timer != null &&
                              !_generalServices.timer!.isActive) {
                        _generalServices.setTimer();
                        locator<AdService>().showInterstitialAd();
                      }
                    }
                  },
                ),
                body: Container(
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.only(
                    top: 10,
                    right: 15,
                    left: 15,
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    controller: _controller,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).padding.top +
                                  AppBar().preferredSize.height),
                          AddPhotoComponent(
                            status: model.photoLoadingStatus,
                            img: model.img,
                            deleteTemp: () => model.setNewImage(null),
                            getImage: model.getImage,
                          ),
                          vSmallSpace,
                          AddTitleComponent(
                              editRecipe: widget.recipe != null,
                              titleController: _titleController,
                              servesController: _servesController,
                              title: model.recipe.title,
                              serves: model.recipe.serves,
                              changeTitle: model.setRecipeTitle,
                              changeServes: model.setServesNumber),
                          vSmallSpace,
                          AddSectionsComponent(
                            recipe: model.recipe,
                            setSectionTitle: model.setSectionTitle,
                            addSection: model.addSection,
                            removeSection: model.removeSection,
                          ),
                          vSmallSpace,
                          AddInstructionsComponent(
                              changeInstruction: model.setInstructions,
                              deleteInstructionsStep:
                                  model.deleteInstructionsStep,
                              insertInstructionStep: model.addInstructionStep,
                              instructions: model.recipe.instructions),
                          vSmallSpace,
                          AddAdvancedComponent(
                            deleteTag: model.deleteTag,
                            toggleAddTag: model.toggleAddTag,
                            tags: model.recipe.tags,
                            toggleTag: model.setTagStatus,
                          ),
                          const SafeArea(
                            child: blankSpace,
                            top: false,
                          ),
                          vSmallSpace
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            model.showAddTag
                ? AddTagTextField(
                    toggleAddTag: model.toggleAddTag,
                    addTag: model.addTag,
                  )
                : blankSpace,
            FullScreenLoadingIndicator(model.loadingStatus)
          ],
        ),
      ),
    );
  }
}
