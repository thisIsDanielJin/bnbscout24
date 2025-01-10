import 'package:bnbscout24/components/tab_bar_item.dart';
import 'package:flutter/material.dart';

class Layout extends StatefulWidget {
  List<TabBarItem> items;

  Layout({super.key, required this.items});

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout>
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
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[300],
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
                  color: Colors.green,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: 
                  widget.items.map((i) => Tab(text: i.name)).toList()
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