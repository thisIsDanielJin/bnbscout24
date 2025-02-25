import 'package:bnbscout24/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:bnbscout24/api/login_manager.dart';
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

class _BookingHistoryState extends State<BookingHistory> {
  late List<Property?> bookingHistory = [];

  void initState() {
    super.initState();
    _loadCardData();
  }

  Future<void> _loadCardData() async {
    final loginManager = Provider.of<LoginManager>(context);
      try {
        List<Booking>? data =
        await Booking.listBookings().then((props) => props ?? []);
        setState(() {
          data = data?.where((booking) => booking.userId == loginManager.loggedInUser?.$id).toList();

        setState(() async {
          for(final booking in data!){
           bookingHistory.add(await Property.getPropertyById(booking.propertyId));
          }
           // Initialize filtered data with all data
        });
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
        itemBuilder: (context, index) {
          final item = bookingHistory[index];
          return Column(
            children: [
              GestureDetector(
                onTap:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailsPage(showBookButton: false ,priceInterval: item.priceInterval, propertyId: item.id, pictureIds: item.pictureIds!.isNotEmpty ? Property.generateImageUrls(item) : [], title: item.name.toString() ?? '', rentPerDay: item.priceIntervalCents ?? 0, description: item.description ?? '', street: item.address.toString() ?? '', area: item.squareMetres.toInt() ?? 0, deskAmount: item.roomAmount.toInt() ?? 0, networkSpeed:  item.mbitPerSecond?.toInt() ?? 0)),
                  );
                },
                child: HorizontalCard(
                  priceInterval: item!.priceInterval ,
                  imageUrl:  item.pictureIds!.isNotEmpty ? Property.generateImageUrls(item)?.elementAt(0) : '',
                  title: item.name.toString() ?? '',
                  pricePerMonth: item.priceIntervalCents ?? 0,
                  streetName: item.address.toString() ?? '',
                  area: item.squareMetres.toInt() ?? 0,
                  deskAmount: item.roomAmount.toInt() ?? 0,
                  networkSpeed: item.mbitPerSecond?.toInt() ?? 0,
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }
}
