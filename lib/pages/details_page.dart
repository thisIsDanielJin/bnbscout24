
import 'package:bnbscout24/api/login_manager.dart';
import 'package:bnbscout24/components/button.dart';
import 'package:bnbscout24/components/page_base.dart';
import 'package:bnbscout24/pages/conversation_page.dart';
import 'package:flutter/material.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:bnbscout24/constants/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../data/property.dart';
import '../components/book_now_calendar.dart';


class DetailsPage extends StatefulWidget {
  final bool showBookButton;
  final Property property;

  DetailsPage({
    super.key,
    this.showBookButton = true,
    required this.property
  });

  @override
  _DetailsPageState createState() => _DetailsPageState();
}
class _DetailsPageState extends State<DetailsPage> {
   List<Widget> images= [];

  @override
  void initState(){
    super.initState();
    images = buildImages();
  }

  @override
  Widget build(BuildContext context) {
    final loginManager = Provider.of<LoginManager>(context);

    return PageBase(
      title: widget.property.name,
      child: Column(
        spacing: Sizes.paddingSmall,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child:  SingleChildScrollView(
            child: 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo Carousel
                  Carousel(),
                  SizedBox(height: 24),

                  // Information Section
                  Center(child: _buildSectionTitle('Information')),
                  SizedBox(height: 8),
                  _buildInfoItem('Property', widget.property.name, Icons.house),
                  _buildInfoItem('Address', widget.property.address, Icons.location_on),
                  _buildInfoRow('Area (m²)', widget.property.squareMetres.toString(), Icons.square_foot, 'Price ${widget.property.priceInterval}', (widget.property.priceIntervalCents / 100.0).toString(), Icons.attach_money),
                  _buildInfoRow('Rooms', widget.property.roomAmount.toString(), Icons.room, 'Mbit/s', widget.property.mbitPerSecond?.toString() ?? "0", Icons.wifi),
                  Divider(height: 40, thickness: 1),

                  // Description Section
                  Center(child: _buildSectionTitle('Description')),
                  SizedBox(height: 12),
                  Text(
                    widget.property.description,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          
          
         
          
          if(widget.property.userId != loginManager.loggedInUser?.$id) ColorButton(
            color: ColorPalette.darkGrey,
            text: "Contact Owner",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ConversationPage(property: widget.property, chatPartnerId: widget.property.userId,),
                            ));
            },
          ),
          if(widget.property.userId != loginManager.loggedInUser?.$id) ColorButton(
            text: "Book Now",
            onPressed: () {
              _showBookingBottomSheet(context);
            },
          )
        ],
      ),
    );
  }

  void _showBookingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BookingBottomSheet(propertyId: widget.property.id);
      },
    );
  }


  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.black87),
              SizedBox(width: 8), // Space between icon and label
              Text(
                '$label:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Container(
            width: double.infinity, // Full width
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget Carousel(){
    if(widget.property.pictureIds!.isNotEmpty) {
      return CarouselSlider(
              items: images,
              options: CarouselOptions(
                height: 200,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: false,
                reverse: false,
                autoPlay: false,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                scrollDirection: Axis.horizontal,
              ),
            );
    }
    return SizedBox(height: 0,);
  }
  List<Widget> buildImages(){
    return List<Widget>.from(Property.generateImageUrls(widget.property)!.map((picture) =>
        Image(image: NetworkImage(picture), fit: BoxFit.cover,)));

  }
  Widget _buildInfoRow(String label1, String value1, IconData icon1, String label2, String value2, IconData icon2) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(icon1, size: 20, color: Colors.black87),
                    SizedBox(width: 8), // Space between icon and label
                    Text(
                      '$label1:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16), // Space between the two items
              Expanded(
                child: Row(
                  children: [
                    Icon(icon2, size: 20, color: Colors.black87),
                    SizedBox(width: 8), // Space between icon and label
                    Text(
                      '$label2:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    value1,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16), // Space between the two boxes
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    value2,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

