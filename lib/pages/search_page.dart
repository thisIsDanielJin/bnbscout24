import 'package:bnbscout24/components/custom_text_input.dart';
import 'package:bnbscout24/components/property_card.dart';
import 'package:bnbscout24/data/booking.dart';
import 'package:bnbscout24/data/property.dart';
import 'package:flutter/material.dart';
import 'package:bnbscout24/pages/filter_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Booking> bookings = [];
  List<Property>? cardData = [];
  List<Property>? _filteredCardData = [];
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _loadData();

    // Add listener to address controller
    _addressController.addListener(() {
      _performFilterAndSearch();
    });

    // Add listener to radius controller
    _radiusController.addListener(() {
      if (_currentPosition != null) {
        _performFilterAndSearch();
      }
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final List<Booking>? bookings = await Booking.listBookings();

      final List<Property>? data =
          await Property.listProperties().then((props) => props ?? []);

      setState(() {
        if (bookings != null) {
          this.bookings = bookings;
        }

        cardData = data;
        _performFilterAndSearch();
      });
    } catch (e) {
      debugPrint('Error loading card data: $e');
    }
  }

  bool isOverlapping(
      DateTime start1, DateTime end1, DateTime start2, DateTime end2) {
    return start1.isBefore(end2) && start2.isBefore(end1);
  }

  Future<List<Property>?> _performFilter(List<Property>? input) async {
    final prefs = await SharedPreferences.getInstance();

    double? priceMin = prefs.getDouble(FilterPage.KEY_PRICE_MIN);
    double? priceMax = prefs.getDouble(FilterPage.KEY_PRICE_MIN);

    double? areaMin = prefs.getDouble(FilterPage.KEY_AREA_MIN);
    double? areaMax = prefs.getDouble(FilterPage.KEY_AREA_MAX);

    String? priceInterval = prefs.getString(FilterPage.KEY_PRICE_INTERVAL);
    DateTime? fromDate =
        DateTime.tryParse(prefs.getString(FilterPage.KEY_FROM_DATE) ?? "");
    DateTime? toDate =
        DateTime.tryParse(prefs.getString(FilterPage.KEY_TO_DATE) ?? "");

    List<Property>? filteredProperties = input?.where((property) {
      // get daily price for calc
      bool priceCond = true;
      if (priceInterval != null && (priceMin != null || priceMax != null)) {
        double propDailyPriceFactor = (property.priceInterval == "Daily"
            ? 1
            : (property.priceInterval == "Weekly" ? 7 : 30));
        double filterDailyPriceFactor = (priceInterval == "Daily"
            ? 1
            : (priceInterval == "Weekly" ? 7 : 30));
        priceCond = (priceMin == null ||
                (priceMin / filterDailyPriceFactor) <
                    (property.priceIntervalCents / propDailyPriceFactor)) &&
            (priceMax == null ||
                (priceMax / filterDailyPriceFactor) >
                    (property.priceIntervalCents / propDailyPriceFactor));
      }

      bool areaCond = (areaMin == null || areaMin < property.squareMetres) &&
          (areaMax == null || areaMax > property.squareMetres);

      bool availabilityCond = bookings.where((booking) {
        return booking.propertyId == property.id &&
            isOverlapping(
                fromDate ?? DateTime.fromMicrosecondsSinceEpoch(0),
                toDate ?? DateTime.fromMicrosecondsSinceEpoch(0),
                booking.startDate!,
                booking.endDate!);
      }).isEmpty;

      return priceCond && areaCond && availabilityCond;
    }).toList();

    return filteredProperties;
  }

  List<Property>? _performSearch(List<Property>? input) {
    if (input == null) return null;

    List<Property> results = input;

    // Apply text search if there's a search term
    if (_addressController.text.isNotEmpty) {
      final searchTerm = _addressController.text.toLowerCase();
      results = results.where((item) {
        final streetName = item.address.toString().toLowerCase();
        final title = item.name.toString().toLowerCase();
        return streetName.contains(searchTerm) || title.contains(searchTerm);
      }).toList();
    }

    // Apply radius filter if location and radius are available
    if (_currentPosition != null && _radiusController.text.isNotEmpty) {
      try {
        final radiusInMeters = double.parse(_radiusController.text) * 1000;
        results = results.where((item) {
          final itemLat = item.geoLat ?? 0.0;
          final itemLng = item.geoLon ?? 0.0;
          final distance = Geolocator.distanceBetween(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            itemLat,
            itemLng,
          );
          return distance <= radiusInMeters;
        }).toList();
      } catch (e) {
        print('Error parsing radius: $e');
      }
    }

    return results;
  }

  void _performFilterAndSearch() async {
    List<Property>? filteredData = await _performFilter(cardData);
    setState(() {
      _filteredCardData = _performSearch(filteredData);
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Handle denied permission
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Handle permanently denied permission
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Location permission permanently denied. Please enable it in settings.'),
          ),
        );
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentPosition = position;
      });

      // Trigger search with new position
      _performFilterAndSearch();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
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
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FilterPage(),
                            ),
                          );
                          _performFilterAndSearch();
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
                          child: CustomTextInput(
                            controller: _radiusController,
                            hint: 'Radius (km)',
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                double? radius = double.tryParse(value);
                                if (radius == null || radius < 0) {
                                  _radiusController.text = '';
                                } else {
                                  _performFilterAndSearch();
                                }
                              }
                            },
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.my_location),
                              onPressed: _getCurrentLocation,
                            ),
                          )),
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
                          itemBuilder: (context, index) =>
                              PropertyCard(item: _filteredCardData![index])),
            ),
          ],
        ),
      ),
    );
  }
}
