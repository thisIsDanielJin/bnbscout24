import 'dart:convert';
import 'package:bnbscout24/components/custom_text_input.dart';
import 'package:bnbscout24/data/property.dart';
import 'package:bnbscout24/pages/details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bnbscout24/components/office_result_card.dart';
import 'package:bnbscout24/pages/filter_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Property>? cardData = [];
  List<Property>? _filteredCardData = [];
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _loadCardData();

    // Add listener to address controller
    _addressController.addListener(() {
      _performSearch();
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  Future<void> _loadCardData() async {
    try {
      final List<Property>? data =
          await Property.listProperties().then((props) => props ?? []);

      setState(() {
        cardData = data;
        _filteredCardData = data; // Initialize filtered data with all data
      });
    } catch (e) {
      debugPrint('Error loading card data: $e');
    }
  }

  void _performSearch() {
    if (_addressController.text.isEmpty) {
      setState(() {
        _filteredCardData = cardData;
      });
      return;
    }

    setState(() {
      _filteredCardData = cardData?.where((item) {
        final streetName = item.address.toString().toLowerCase();
        final title = item.name.toString().toLowerCase();
        final searchTerm = _addressController.text.toLowerCase();

        // Basic text search
        bool matchesSearch =
            streetName.contains(searchTerm) || title.contains(searchTerm);

        // Radius check if position and radius are available
        if (matchesSearch &&
            _currentPosition != null &&
            _radiusController.text.isNotEmpty) {
          final itemLat = item.geoLat ?? 0.0;
          final itemLng = item.geoLon ?? 0.0;
          final distance = Geolocator.distanceBetween(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            itemLat,
            itemLng,
          );
          // Convert radius from km to meters
          final radiusInMeters = double.parse(_radiusController.text) * 1000;
          return distance <= radiusInMeters;
        }

        return matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Search',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const FaIcon(FontAwesomeIcons.sliders),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FilterPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: CustomTextInput(
                          controller: _addressController,
                          hint: 'Address',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: _radiusController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Radius (km)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.my_location),
                              onPressed:
                                  () {}, // Empty function - button does nothing
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_currentPosition != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Current position: ${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: _filteredCardData!.isEmpty &&
                      _addressController.text.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredCardData!.isEmpty
                      ? const Center(child: Text('No results found'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: _filteredCardData?.length,
                          itemBuilder: (context, index) {
                            final item = _filteredCardData?[index];
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap:(){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => DetailsPage(pictureIds: item.pictureIds!.isNotEmpty ? Property.generateImageUrls(item) : [], title: item.name.toString() ?? '', rentPerDay: item.squareMetres ?? 0.0, description: item.description ?? '', street: item.address.toString() ?? '', area: item.squareMetres.toInt() ?? 0, deskAmount: item.roomAmount.toInt() ?? 0, networkSpeed:  item.mbitPerSecond?.toInt() ?? 0)),
                                    );
                                  },
                                  child: HorizontalCard(
                                    imageUrl:  item!.pictureIds!.isNotEmpty ? Property.generateImageUrls(item)?.elementAt(0) : '',
                                    title: item.name.toString() ?? '',
                                    pricePerMonth: item.priceIntervalCents.toInt() ?? 0,
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
            ),
          ],
        ),
      ),
    );
  }
}
