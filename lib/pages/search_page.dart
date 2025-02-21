import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bnbscout24/components/office_result_card.dart';
import 'package:bnbscout24/pages/filter_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> cardData = [];
  List<dynamic> _filteredCardData = [];
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();

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
      final String response =
          await rootBundle.loadString('assets/main_card_data.json');
      final List<dynamic> data = json.decode(response);
      setState(() {
        cardData = data;
        _filteredCardData = data; // Initialize filtered data with all data
      });
    } catch (e) {
      print('Error loading card data: $e');
    }
  }

  void _performSearch() {
    if (_addressController.text.isEmpty) {
      setState(() {
        // If no search term, show all results
        _filteredCardData = cardData;
      });
      return;
    }

    setState(() {
      _filteredCardData = cardData.where((item) {
        final streetName = item['streetName'].toString().toLowerCase();
        final title = item['title'].toString().toLowerCase();
        final searchTerm = _addressController.text.toLowerCase();

        // Search in both street name and title
        return streetName.contains(searchTerm) || title.contains(searchTerm);
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
                        child: TextField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            hintText: 'Enter address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: _filteredCardData.isEmpty &&
                      _addressController.text.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredCardData.isEmpty
                      ? const Center(child: Text('No results found'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: _filteredCardData.length,
                          itemBuilder: (context, index) {
                            final item = _filteredCardData[index];
                            return Column(
                              children: [
                                HorizontalCard(
                                  imageUrl: item['imageUrl']?.toString() ?? '',
                                  title: item['title']?.toString() ?? '',
                                  pricePerMonth: (item['pricePerMonth'] is num)
                                      ? item['pricePerMonth'].toInt()
                                      : 0,
                                  streetName:
                                      item['streetName']?.toString() ?? '',
                                  area: (item['area'] is num)
                                      ? item['area'].toInt()
                                      : 0,
                                  deskAmount: (item['deskAmount'] is num)
                                      ? item['deskAmount'].toInt()
                                      : 0,
                                  networkSpeed: (item['networkSpeed'] is num)
                                      ? item['networkSpeed'].toInt()
                                      : 0,
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
