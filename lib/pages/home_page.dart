import 'package:bnbscout24/components/button.dart';
import 'package:bnbscout24/components/form_input.dart';
import 'package:bnbscout24/components/custom_text_input.dart';
import 'package:bnbscout24/components/office_result_card.dart';
import 'package:bnbscout24/constants/constants.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:bnbscout24/data/property.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Property> properties = List.empty();
  List<Marker> markers = List.empty();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    List<Property>? props = await Property.listProperties();
    if (props != null) {
      setState(() {
        properties = props;
        markers = props
            .map((prop) => Marker(
                point: LatLng(prop.geoLat, prop.geoLon),
                child: Icon(Icons.home)))
            .toList();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter:
            LatLng(52.520008, 13.404954), // Center the map over London
        initialZoom: 12.2,
      ),
      children: [
        TileLayer(
          // Bring your own tiles
          urlTemplate:
              'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // For demonstration only
          userAgentPackageName: 'com.example.app', // Add your app identifier
          tileProvider: CancellableNetworkTileProvider(),
          // And many more recommended properties!
        ),
        RichAttributionWidget(
          // Include a stylish prebuilt attribution widget that meets all requirments
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () => launchUrl(Uri.parse(
                  'https://openstreetmap.org/copyright')), // (external)
            ),
            // Also add images...
          ],
        ),
        PopupMarkerLayer(
          options: PopupMarkerLayerOptions(
              markers: markers,
              popupDisplayOptions: PopupDisplayOptions(
                  builder: (BuildContext context, Marker marker) {

                    List<Property> foundProps = properties.where((p) => p.geoLat == marker.point.latitude && p.geoLon == marker.point.longitude).toList();


                return Container(
                  padding: EdgeInsets.all(Sizes.paddingRegular),
                  height: 300,
                  width: 500,
                  decoration: BoxDecoration(
                    color: ColorPalette.white,
                    borderRadius: BorderRadius.circular(Sizes.borderRadius)
                    ),
  
                  child: ListView(children: foundProps.map((p) => Container(
                      margin: EdgeInsets.only(bottom: Sizes.paddingRegular),
                      child: HorizontalCard(imageUrl: (p.pictureIds?.length ?? 0) > 0 ? Property.generateImageUrls(p)![0] : "", title: p.name, pricePerMonth: round(p.priceIntervalCents / 100).toInt(), streetName: p.address, area: p.squareMetres.floor(), deskAmount: p.roomAmount, networkSpeed: p.mbitPerSecond?.floor() ?? 0),
                    )).toList())
                  
                );
              })),
        )
      ],
    );
  }
}
