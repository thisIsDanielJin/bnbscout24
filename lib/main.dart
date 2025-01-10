import 'package:bnbscout24/components/tab_bar.dart';
import 'package:bnbscout24/components/tab_bar_item.dart';
import 'package:bnbscout24/pages/home_page.dart';
import 'package:bnbscout24/pages/converstations_page.dart';
import 'package:bnbscout24/pages/profile_page.dart';
import 'package:bnbscout24/pages/properties_page.dart';
import 'package:bnbscout24/pages/search_page.dart';
import 'package:flutter/material.dart';

void main() {


  runApp(MaterialApp(
    home: Layout(
      items: [
        TabBarItem(page: HomePage(), name: "Home"),
        TabBarItem(page: SearchPage(), name: "Search"),
        TabBarItem(page: PropertiesPage(), name: "Properties"),
        TabBarItem(page: ConversationsPage(), name: "Inbox"),
        TabBarItem(page: ProfilePage(), name: "Profile"),


      ],
    )
  ));
}
