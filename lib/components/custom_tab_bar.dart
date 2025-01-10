import 'package:bnbscout24/components/custom_tab_bar_item.dart';
import 'package:bnbscout24/constants/constants.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  final List<CustomTabBarItem> items;

  const CustomTabBar({super.key, required this.items});

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: widget.items.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Sizes().initialize(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: 
                  widget.items.map((i) => i.page).toList()                
              ),
            ),
            // give the tab bar a height [can change hheight to preferred height]
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: darkGrey,
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
              ),

              child: TabBar(
                controller: _tabController,
                // give the indicator a decoration (color and border radius)
                indicator: BoxDecoration(
                  
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                  color: white,
                  
                ),
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                dividerHeight: 0,
                labelColor: darkGrey,
                unselectedLabelColor: white,
                tabs: 
                  widget.items.asMap().map((idx, i) => MapEntry(idx, Tab(child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Center(
                      child: i.tab_widget,
                    ),
                  )))).values.toList()
                ,
              ),
            ),
            // tab bar view here
            
          ],
        ),
      ),
    );
  }
}