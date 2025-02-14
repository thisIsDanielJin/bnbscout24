
import 'package:flutter/material.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:bnbscout24/constants/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';


class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}
class _DetailsPageState extends State<DetailsPage> {
  final String address = "123 Example Street";
  final double area = 150.0;
  final double rentalPrice = 120000.0;
  final List<Map<String, dynamic>> attributes = [
    {"text": "Attribute 1", "icon": Icons.star},
    {"text": "Attribute 2", "icon": Icons.euro},
    {"text": "Attribute 3", "icon": Icons.check},
    {"text": "Attribute 4", "icon": Icons.bolt},
    {"text": "Attribute 5", "icon": Icons.eco},
  ];
  final String description = "Lorem ipsum dolor sit amet, consectetur s adipiscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet elita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit";
  List<Widget> images = [
    Image(image: AssetImage('images/photo.jpg'),
      height: 100,
    ),
    Image(image: AssetImage('images/photo1.jpg'),
      height: 100,
    ),
    Image(image: AssetImage('images/photo2.jpg'),
      height: 100,
    )
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 80), // Add padding to avoid overlap with the button
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo Carousel
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        CarouselSlider(
                          items: images,
                          options: CarouselOptions(
                            height: 150,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.8,
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
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Information Section
                  Center(child: _buildSectionTitle('Information')),
                  SizedBox(height: 8),
                  _buildInfoItem('Address', address, Icons.location_on),
                  _buildInfoRow('Area (m²)', area.toString(), Icons.square_foot, 'Rental Price', '\$$rentalPrice', Icons.attach_money),
                  Divider(height: 40, thickness: 1),

                  // Attributes Section
                  Center(child: _buildSectionTitle('Attributes')),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8.0, // Horizontal space between items
                    runSpacing: 8.0, // Vertical space between lines
                    children: attributes.map((attr) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(attr["icon"], size: 20, color: Colors.black87),
                            SizedBox(width: 8), // Space between icon and text
                            Text(
                              attr["text"],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  Divider(height: 40, thickness: 1),

                  // Description Section
                  Center(child: _buildSectionTitle('Description')),
                  SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Static "Book Now" Button
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: EdgeInsets.all(Sizes.paddingBig),
                  elevation: 0, // No shadow
                ),
                onPressed: () {},
                child: Text(
                  'Book Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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