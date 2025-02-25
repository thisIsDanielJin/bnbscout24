import 'package:bnbscout24/components/office_result_card.dart';
import 'package:bnbscout24/constants/constants.dart';
import 'package:bnbscout24/data/property.dart';
import 'package:bnbscout24/pages/details_page.dart';
import 'package:flutter/material.dart';

class PropertyCard extends StatelessWidget {
  Property item;

  PropertyCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
                    onTap:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailsPage(property: item)),
                      );
                    },
                    child: HorizontalCard(
                      priceInterval: item!.priceInterval ,
                      imageUrl:  item.pictureIds!.isNotEmpty ? Property.generateImageUrls(item)?.elementAt(0) : Constants.unknownImageUrl,
                      title: item.name.toString() ?? '',
                      pricePerMonth: item.priceIntervalCents ?? 0,
                      streetName: item.address.toString() ?? '',
                      area: item.squareMetres.toInt() ?? 0,
                      deskAmount: item.roomAmount.toInt() ?? 0,
                      networkSpeed: item.mbitPerSecond?.toInt() ?? 0,
                    ),
                  );
  }
}