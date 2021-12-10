import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';

import 'AddTagItem.dart';
import 'GenericButton.dart';

class SearchFiltersComponents extends StatefulWidget {
  final bool expandFilters;
  final AnimationController controller;
  final Animation animation;
  const SearchFiltersComponents({
    required this.animation,
    required this.controller,
    Key? key,
    required this.expandFilters,
  }) : super(key: key);

  @override
  State<SearchFiltersComponents> createState() =>
      _SearchFiltersComponentsState();
}

class _SearchFiltersComponentsState extends State<SearchFiltersComponents>
    with TickerProviderStateMixin {
  List<MapEntry<String, bool>> tagList = {
    'Snack': false,
    'Breakfast': false,
    'Lunch': false,
    'Dinner': false,
    'Dessert': false,
    'Drink': false,
  }.entries.toList();
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizeTransition(
        sizeFactor: widget.controller,
        child: SingleChildScrollView(
          child: Container(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tags',
                    style: TextStyle(fontSize: 15),
                  ),
                  vSmallSpace,
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                        spacing: 5,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runSpacing: 5,
                        children: [
                          for (int i = 0; i < tagList.length; i++)
                            TagItem(
                              deleteTag: (_) {},
                              selected: tagList[i].value,
                              title: tagList[i].key,
                              toggleTag: (_) {},
                            ),
                          GenericButton(
                            onTap: () {
                              // toggleAddTag();
                            },
                            title: '+',
                            invertColors: true,
                            shrink: true,
                            fontsize: 15,
                          ),
                        ]),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
