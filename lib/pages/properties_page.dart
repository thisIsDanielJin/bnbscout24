import 'package:appwrite/appwrite.dart';
import 'package:bnbscout24/pages/create_property.dart';
import 'package:flutter/material.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:bnbscout24/components/office_result_card.dart';
import 'package:bnbscout24/constants/constants.dart';
import 'package:bnbscout24/components/booking_request_item.dart';
import 'package:bnbscout24/data/booking.dart';
import 'package:bnbscout24/data/property.dart';
import 'package:provider/provider.dart';
import 'package:bnbscout24/api/login_manager.dart';

class PropertiesPage extends StatefulWidget {
  const PropertiesPage({super.key});

  @override
  State<PropertiesPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Booking> bookingRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBookingRequests();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookingRequests() async {
    setState(() => isLoading = true);
    try {
      final loginManager = Provider.of<LoginManager>(context, listen: false);

      // First get a list of your properties to use a valid property ID
      List<Property>? properties = await Property.listProperties();
      if (properties == null || properties.isEmpty) {
        setState(() {
          bookingRequests = [];
          isLoading = false;
        });
        return;
      }

      // Create mock bookings with valid property ID
      final mockBookings = [
        Booking(
          id: ID.unique(),
          propertyId: properties.first.id, // Use actual property ID
          userId: loginManager.loggedInUser!.$id,
          status: "pending",
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(days: 3)),
        ),
        Booking(
          id: ID.unique(),
          propertyId: properties.first.id, // Use actual property ID
          userId: loginManager.loggedInUser!.$id,
          status: "pending",
          startDate: DateTime.now().add(Duration(days: 7)),
          endDate: DateTime.now().add(Duration(days: 10)),
        ),
      ];

      setState(() {
        bookingRequests = mockBookings;
      });
    } catch (e) {
      debugPrint('Error loading booking requests: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _handleBookingAction(Booking booking, String status) async {
    try {
      await Booking.updateBooking(booking.id, status: status);
      _loadBookingRequests(); // Reload the list
    } catch (e) {
      debugPrint('Error updating booking: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(Sizes.paddingRegular),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: Sizes.paddingBig),
                  child: Text(
                    "Your Properties",
                    style: TextStyle(
                        fontSize: Sizes.textSizeBig,
                        fontWeight: FontWeight.bold),
                  )),
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: "Overview"),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Booking Requests"),
                        SizedBox(width: 4),
                        if (bookingRequests.isNotEmpty)
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: ColorPalette.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              bookingRequests.length.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Overview Tab
                    ListView(
                      children: [
                        SizedBox(height: Sizes.paddingRegular),
                        // Your property cards would go here
                        // Example card:
                        HorizontalCard(
                          imageUrl: "your_image_url",
                          title: "Generic Office Space",
                          streetName: "Hauptstraße 1",
                          area: 150,
                          deskAmount: 25,
                          networkSpeed: 10000,
                          pricePerMonth: 1800,
                          priceInterval: "Monthly",
                        ),
                        SizedBox(height: Sizes.paddingRegular),
                        // Add Property Button
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CreatePropertyPage(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(Sizes.paddingRegular),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.grey),
                                SizedBox(width: 8),
                                Text(
                                  "Add Property",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: Sizes.textSizeRegular,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Booking Requests Tab
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: bookingRequests.length,
                            itemBuilder: (context, index) {
                              final booking = bookingRequests[index];
                              return FutureBuilder<Property?>(
                                future: Property.getPropertyById(
                                    booking.propertyId),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return SizedBox.shrink();
                                  }
                                  final property = snapshot.data!;
                                  return BookingRequestItem(
                                    title: property.name,
                                    imageUrl: property.pictureIds?.isNotEmpty ==
                                            true
                                        ? Property.generateImageUrls(property)!
                                            .first
                                        : '',
                                    startDate:
                                        booking.startDate ?? DateTime.now(),
                                    endDate: booking.endDate ?? DateTime.now(),
                                    onAccept: () => _handleBookingAction(
                                        booking, "accepted"),
                                    onDecline: () => _handleBookingAction(
                                        booking, "declined"),
                                  );
                                },
                              );
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
