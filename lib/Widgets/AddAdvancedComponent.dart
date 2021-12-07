import 'package:flutter/material.dart';
import 'package:personal_recipes/Constants/Spacing.dart';
import 'package:personal_recipes/Widgets/GenericButton.dart';

import 'AddTagItem.dart';

class AddAdvancedComponent extends StatelessWidget {
  final void Function() toggleAddTag;
  final void Function(String title) deleteTag;
  final void Function(String tagKey) toggleTag;
  final Map<String, bool> tags;
  const AddAdvancedComponent({
    Key? key,
    required this.deleteTag,
    required this.toggleAddTag,
    required this.toggleTag,
    required this.tags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, bool>> tagList = tags.entries.toList();
    return ListTileTheme(
      dense: true,
      child: ExpansionTile(
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        tilePadding: const EdgeInsets.only(right: 12),
        title: const Text('Tags', style: TextStyle(fontSize: 17)),
        children: [
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
                      deleteTag: deleteTag,
                      selected: tagList[i].value,
                      title: tagList[i].key,
                      toggleTag: toggleTag,
                    ),
                  GenericButton(
                    onTap: () {
                      toggleAddTag();
                    },
                    title: '+',
                    invertColors: true,
                    shrink: true,
                    fontsize: 15,
                  ),
                ]),
          ),
          vSmallSpace,
          // Row(
          //   children: [
          //     Expanded(
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           const Text('Prep time', style: TextStyle(fontSize: 15)),
          //           vTinySpace,
          //           Row(
          //             children: [
          //               SizedBox(
          //                 width: 70,
          //                 child: CustomTextFormField(
          //                   keyboardType: TextInputType.number,
          //                   onChanged: (_) {},
          //                 ),
          //               ),
          //               hSmallSpace,
          //               const Text(
          //                 'minutes',
          //                 style: TextStyle(fontSize: 15),
          //               )
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //     hSmallSpace,
          //     Expanded(
          // child: Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           const Text('Cooking time', style: TextStyle(fontSize: 15)),
          //           vTinySpace,
          //           Row(
          //             children: [
          //               SizedBox(
          //                 width: 70,
          //                 child: CustomTextFormField(
          //                   keyboardType: TextInputType.number,
          //                   onChanged: (_) {},
          //                 ),
          //               ),
          //               hSmallSpace,
          //               const Text(
          //                 'minutes',
          //                 style: TextStyle(fontSize: 15),
          //               )
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          // vSmallSpace,
        ],
      ),
    );
  }
}
