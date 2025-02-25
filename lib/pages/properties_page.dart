import 'package:appwrite/appwrite.dart';
import 'package:bnbscout24/components/property_card.dart';
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
  List<Property> ownedProperties = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    try {
      final loginManager = Provider.of<LoginManager>(context, listen: false);


      List<Property>? properties = await Property.listProperties();
      properties = properties?.where((p) => p.userId == loginManager.loggedInUser!.$id).toList();

      List<Booking>? bookings = await Booking.listBookings();
      bookings = bookings?.where((b) => (properties?.map((p) => p.id).contains(b.propertyId) ?? false)).toList();
      
      setState(() {
        bookingRequests = bookings ?? [];
        ownedProperties = properties ?? [];
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading booking requests: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void>  _handleBookingAction(Booking booking, String status) async {
    try {
      await Booking.updateBooking(booking.id, status: status);
      _loadData(); // Reload the list
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
         
                        ...ownedProperties.map((p) => PropertyCard(item: p)),
                      
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
                              final property = ownedProperties.firstWhere((p) => p.id == booking.propertyId);
                              return BookingRequestItem(
                                    title: property.name,
                                    status: booking.status,
                                    imageUrl: property.pictureIds?.isNotEmpty ==
                                            true
                                        ? Property.generateImageUrls(property)!
                                            .first
                                        : '',
                                    startDate:
                                        booking.startDate ?? DateTime.now(),
                                    endDate: booking.endDate ?? DateTime.now(),
                                    onAccept: () => _handleBookingAction(
                                        booking, "approved"),
                                    onDecline: () => _handleBookingAction(
                                        booking, "declined"),
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
