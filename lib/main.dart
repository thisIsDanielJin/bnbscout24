import 'package:bnbscout24/components/custom_tab_bar.dart';
import 'package:bnbscout24/components/custom_tab_bar_item.dart';
import 'package:bnbscout24/constants/constants.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:bnbscout24/pages/conversations_page.dart';
import 'package:bnbscout24/pages/home_page.dart';
import 'package:bnbscout24/pages/profile_page.dart';
import 'package:bnbscout24/pages/properties_page.dart';
import 'package:bnbscout24/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: ColorPalette.white,
      ),
      home: CustomTabBar(
        items: [
          CustomTabBarItem(
              page: HomePage(),
              tab_widget:
                  FaIcon(FontAwesomeIcons.map, size: Sizes.navBarIconSize)),
          CustomTabBarItem(
              page: SearchPage(),
              tab_widget: FaIcon(FontAwesomeIcons.magnifyingGlass,
                  size: Sizes.navBarIconSize)),
          CustomTabBarItem(
              page: PropertiesPage(),
              tab_widget:
                  FaIcon(FontAwesomeIcons.house, size: Sizes.navBarIconSize)),
          CustomTabBarItem(
              page: ConversationsPage(),
              tab_widget:
                  FaIcon(FontAwesomeIcons.inbox, size: Sizes.navBarIconSize)),
          CustomTabBarItem(
              page: ProfilePage(),
              tab_widget:
                  FaIcon(FontAwesomeIcons.user, size: Sizes.navBarIconSize)),
        ],
      )));
}
