import 'package:flutter/cupertino.dart';

class TabsNotifier extends ChangeNotifier {
  int _currentTabIndex = 0;

  set setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  get currentTabIndex {
    return _currentTabIndex;
  }
}
