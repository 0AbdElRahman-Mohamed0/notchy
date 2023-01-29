import 'package:flutter/material.dart';

export 'package:provider/provider.dart';

class NavigationIndexProvider extends ChangeNotifier {
  int index = 0;

  Future changeIndex(int newIndex) async{
    index = newIndex;
    notifyListeners();
  }
}
