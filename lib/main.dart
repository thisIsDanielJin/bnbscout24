import 'package:bnbscout24/components/custom_tab_bar.dart';
import 'package:bnbscout24/components/custom_tab_bar_item.dart';
import 'package:bnbscout24/pages/home_page.dart';
import 'package:bnbscout24/pages/converstations_page.dart';
import 'package:bnbscout24/pages/profile_page.dart';
import 'package:bnbscout24/pages/properties_page.dart';
import 'package:bnbscout24/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {


  runApp(MaterialApp(
    home: CustomTabBar(
      items: [
        CustomTabBarItem(page: HomePage(), tab_widget: FaIcon(FontAwesomeIcons.map)),
        CustomTabBarItem(page: SearchPage(), tab_widget: FaIcon(FontAwesomeIcons.magnifyingGlass)),
        CustomTabBarItem(page: PropertiesPage(), tab_widget: FaIcon(FontAwesomeIcons.house)),
        CustomTabBarItem(page: ConversationsPage(), tab_widget: FaIcon(FontAwesomeIcons.inbox)),
        CustomTabBarItem(page: ProfilePage(), tab_widget: FaIcon(FontAwesomeIcons.person)),


      ],
    )
  ));
}
