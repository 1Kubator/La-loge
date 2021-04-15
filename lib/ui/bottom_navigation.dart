import 'package:flutter/material.dart';
import 'package:la_loge/resources/images.dart';

class BottomNavigation extends StatefulWidget {
  static const id = 'bottom_navigation';

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int screenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: screenIndex,
        children: [],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColorDark,
        currentIndex: screenIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
              icon: getUnselectedThemedIcon(Images.navBarHome, context),
              label: '',
              activeIcon: getSelectedThemedIcon(Images.navBarHome, context)),
          BottomNavigationBarItem(
              icon: getUnselectedThemedIcon(Images.navBarStore, context),
              label: '',
              activeIcon: getSelectedThemedIcon(Images.navBarStore, context)),
          BottomNavigationBarItem(
              icon: getUnselectedThemedIcon(Images.navBarAppointment, context),
              label: '',
              activeIcon:
                  getSelectedThemedIcon(Images.navBarAppointment, context)),
          BottomNavigationBarItem(
              icon: getUnselectedThemedIcon(Images.navBarProfile, context),
              label: '',
              activeIcon: getSelectedThemedIcon(Images.navBarProfile, context)),
        ],
      ),
    );
  }

  Widget getUnselectedThemedIcon(String icon, BuildContext context) {
    return Image.asset(
      icon,
      height: 25,
      color: Theme.of(context).primaryColorLight.withOpacity(0.8),
    );
  }

  Widget getSelectedThemedIcon(String icon, BuildContext context) {
    return Image.asset(
      icon,
      height: 26,
      color: Colors.white.withOpacity(0.8),
    );
  }
}