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
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    //Note: moved the controller down here so that the length is being updated if the landlord status changes.
    TabController tabController =
        TabController(length: widget.items.length, vsync: this);

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: // give the tab bar a height [can change hheight to preferred height]
          Container(
        margin: EdgeInsets.all(Sizes.navBarMargin),
        decoration: BoxDecoration(
          color: ColorPalette.darkGrey,
          borderRadius: BorderRadius.circular(
            Sizes.navBarIconSize +
                Sizes.navBarIconMargin +
                Sizes.navBarIconPadding,
          ),
        ),
        child: TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          padding: EdgeInsets.all(Sizes.navBarIconMargin),
          controller: tabController,
          // give the indicator a decoration (color and border radius)
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(
              Sizes.navBarIconSize,
            ),
            color: ColorPalette.white,
          ),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          dividerHeight: 0,
          labelColor: ColorPalette.darkGrey,
          unselectedLabelColor: ColorPalette.white,
          tabs: widget.items
              .asMap()
              .map((idx, i) => MapEntry(
                  idx,
                  SizedBox(
                    width: Sizes.navBarIconSize + Sizes.navBarIconPadding,
                    height: Sizes.navBarIconSize + Sizes.navBarIconPadding,
                    child: Tab(
                      child: i.tab_widget,
                    ),
                  )))
              .values
              .toList(),
        ),
      ),
      // tab bar view here,
      body: TabBarView(
          controller: tabController,
          children: widget.items.map((i) => i.page).toList()),
    );
  }
}
