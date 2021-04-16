import 'package:flutter/cupertino.dart';

class TabsNotifier extends ChangeNotifier {
  int _tabIndex = 0;

  set setTabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  get tabIndex {
    return _tabIndex;
  }
}
