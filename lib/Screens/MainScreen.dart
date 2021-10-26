import 'package:flutter/material.dart';
import 'package:personal_recipes/Services/general_services.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
   
        final model = Provider.of<GeneralServices>(context);
        return Scaffold(
          body: IndexedStack(index: model.index, children: model.screens),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Theme.of(context).backgroundColor,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: model.index,
            onTap: model.setIndex,
            items: const [
               BottomNavigationBarItem(
                label: '',
                tooltip: '',
                icon: Center(child: Icon(Icons.menu_book)),
              ),
               BottomNavigationBarItem(
                label: '',
                tooltip: '',
                icon: Icon(Icons.add_sharp),
              ),
            ],
          ),
          
    );
  }
}
