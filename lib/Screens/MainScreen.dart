import 'package:flutter/material.dart';
import 'package:personal_recipes/Services/GeneralServices.dart';
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
            items:  [
               BottomNavigationBarItem(
                label: '',
                tooltip: '',
                icon: Center(child: Icon(Icons.menu_book, color: model.index == 0 ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.5), size: model.index == 0 ? 24: 18)),
              ),
               BottomNavigationBarItem(
                label: '',
                tooltip: '',
                icon: Icon(Icons.add_sharp, 
                 color: model.index == 1 ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.5), size: model.index == 1 ? 24: 18),
              ),
            ],
          ),
          
    );
  }
}
