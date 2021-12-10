import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/Widgets/General%20Widgets/AddTagItem.dart';

import '../General Widgets/GenericButton.dart';

class SearchFiltersComponents extends StatefulWidget {
  final Function() toggleAddTag;
  final Function(String) toggleTag;
  final Map<String, bool> tagList;
  final bool expandFilters;
  final AnimationController controller;
  final Animation animation;
  const SearchFiltersComponents({
    required this.toggleAddTag,
    required this.toggleTag,
    required this.tagList,
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
                          for (int i = 0; i < widget.tagList.length; i++)
                            TagItem(
                              key: ValueKey(widget.tagList.entries.toList()[i].key),
                              deleteTag: (_) {},
                              selected: widget.tagList.entries.toList()[i].value,
                              title: widget.tagList.entries.toList()[i].key,
                              toggleTag: widget.toggleTag,
                            ),
                          GenericButton(
                            onTap: () {
                              widget.toggleAddTag();
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
