import 'package:flutter/material.dart';
import 'package:la_loge/providers/tabs_notifier.dart';
import 'package:la_loge/resources/images.dart';
import 'package:la_loge/ui/appointment/appointment_screen_navigator.dart';
import 'package:la_loge/ui/home/home_screen_navigator.dart';
import 'package:la_loge/ui/store/store_screen_navigator.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatefulWidget {
  static const id = 'bottom_navigation';

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  var screens = [
    HomeScreenNavigator(),
    StoreScreenNavigator(),
    AppointmentScreenNavigator(),
  ];

  @override
  Widget build(BuildContext context) {
    final tabNotifier = Provider.of<TabsNotifier>(context);
    return Scaffold(
      body: IndexedStack(
        index: tabNotifier.currentTabIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          tabNotifier.setTabIndex = index;
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColorDark,
        currentIndex: tabNotifier.currentTabIndex,
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
      color: Colors.white.withOpacity(0.9),
    );
  }
}
