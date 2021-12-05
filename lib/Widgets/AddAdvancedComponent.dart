import 'package:flutter/material.dart';

class AddAdvancedComponent extends StatelessWidget {
  const AddAdvancedComponent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ListTileTheme(
      dense: true,
      child: ExpansionTile(
        tilePadding: EdgeInsets.only(right: 12),
        title: Text('Advanced', style: TextStyle(fontSize: 17)),
        children: [],
      ),
    );
  }
}
