import 'package:bnbscout24/components/property_card.dart';
import 'package:bnbscout24/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:bnbscout24/api/login_manager.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../components/office_result_card.dart';
import '../data/booking.dart';
import '../data/property.dart';
import 'details_page.dart';

class BookingHistory extends StatefulWidget {
  const BookingHistory({super.key});

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

class BookingItem {
  Property property;
  Booking booking;

  BookingItem({ required this.property, required this.booking });
}

class _BookingHistoryState extends State<BookingHistory> {
  late List<BookingItem> bookingHistory = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,() {
    _loadCardData();
    });
  }

  Future<void> _loadCardData() async {
    final loginManager = Provider.of<LoginManager>(context, listen: false);
      try {
        List<Booking>? data =
        await Booking.listBookings().then((props) => props ?? []);

        data = data?.where((booking) => booking.userId == loginManager.loggedInUser?.$id).toList();

        for(final booking in data!){
          bookingHistory.add(BookingItem(property: (await Property.getPropertyById(booking.propertyId))!, booking: booking));
        }
        setState(() {
          bookingHistory = [...bookingHistory];
        });

      }catch (e) {
        debugPrint('Error loading card data: $e');
      }
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.white,
        title: Text('Booking Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: bookingHistory.length,
        itemBuilder: (context, index) => Column(
          children: [
            Text("${DateFormat("yMd").format(bookingHistory[index].booking.startDate!)} - ${DateFormat("yMd").format(bookingHistory[index].booking.endDate!)}"),
            PropertyCard(item: bookingHistory[index].property),
          ],
        )
      ),
    );
  }
}
