import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bnbscout24/components/office_result_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> cardData = [];
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCardData();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  Future<void> _loadCardData() async {
    try {
      print('Starting to load card data...');
      final String response =
          await rootBundle.loadString('assets/main_card_data.json');
      print('Response loaded: $response');
      final List<dynamic> data = json.decode(response);
      print('Data decoded: $data');
      setState(() {
        cardData = data;
      });
      print('Card data set: $cardData');
    } catch (e) {
      print('Error loading card data: $e');
    }
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
                  const Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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
              child: cardData.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: cardData.length,
                      itemBuilder: (context, index) {
                        final item = cardData[index];
                        return Column(
                          children: [
                            HorizontalCard(
                              imageUrl: item['imageUrl']?.toString() ?? '',
                              title: item['title']?.toString() ?? '',
                              pricePerMonth: (item['pricePerMonth'] is num)
                                  ? item['pricePerMonth'].toInt()
                                  : 0,
                              streetName: item['streetName']?.toString() ?? '',
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
