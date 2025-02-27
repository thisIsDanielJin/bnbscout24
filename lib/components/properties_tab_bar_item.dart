import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../api/login_manager.dart';
import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../data/booking.dart';
import '../data/message.dart';
import '../data/property.dart';

class PropertiesTabBarItem extends StatefulWidget {
  const PropertiesTabBarItem({super.key});

  @override
  State<PropertiesTabBarItem> createState() => _PropertiesTabBarItemState();
}

class _PropertiesTabBarItemState extends State<PropertiesTabBarItem> {
  RealtimeSubscription? bookingSub;
  int bookings = 0;

  void loadBookings() async {
    final loginManager = Provider.of<LoginManager>(context, listen: false);

    List<Property>? properties = await Property.listProperties();
    properties = properties?.where((p) => p.userId == loginManager.loggedInUser!.$id).toList();

    List<Booking>? bookings = await Booking.listBookings();
    bookings = bookings?.where((b) => (properties?.map((p) => p.id).contains(b.propertyId) ?? false) && b.status == "booked").toList();

    setState(() {
      this.bookings = bookings?.length ?? 0;
    });
  }

  @override
  void dispose() {
    super.dispose();
    bookingSub?.close();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      bookingSub = Booking.subsribeBookings();

      bookingSub?.stream.listen((msg) {
        loadBookings();
      });
      loadBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FaIcon(FontAwesomeIcons.house,
            size: Sizes.navBarIconSize),
        if (bookings > 0) Positioned(
            top: 0,
            left: 5,
            child: Container(
                width: 16,
                height: 16,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: ColorPalette.primary, borderRadius: BorderRadius.circular(7)),
                child: Text(bookings.toString(),
                  style: TextStyle(fontSize: 12),)
            ))
      ],
    );
  }
}
