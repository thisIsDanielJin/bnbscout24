import 'package:bnbscout24/components/custom_tab_bar.dart';
import 'package:bnbscout24/components/custom_tab_bar_item.dart';
import 'package:bnbscout24/pages/home_page.dart';
import 'package:bnbscout24/pages/converstations_page.dart';
import 'package:bnbscout24/pages/profile_page.dart';
import 'package:bnbscout24/pages/properties_page.dart';
import 'package:bnbscout24/pages/search_page.dart';
import 'package:flutter/material.dart';

void main() {


  runApp(MaterialApp(
    home: CustomTabBar(
      items: [
        CustomTabBarItem(page: HomePage(), name: "Home"),
        CustomTabBarItem(page: SearchPage(), name: "Search"),
        CustomTabBarItem(page: PropertiesPage(), name: "Properties"),
        CustomTabBarItem(page: ConversationsPage(), name: "Inbox"),
        CustomTabBarItem(page: ProfilePage(), name: "Profile"),


      ],
    )
  ));
}
