import 'package:appwrite/appwrite.dart';
import 'package:bnbscout24/api/client.dart';

final String DB_ID = '6780faa636107ddbb899';
final String COLLECTION_ID = '6780fb97607609a113df';

class Property {
  final String name;
  final String userId;
  final String description;
  final String street;
  final String city;
  final int zipCode;
  final List<String> pictureIds;

  Property(
      {required this.name,
      required this.userId,
      required this.description,
      required this.street,
      required this.city,
      required this.zipCode,
      required this.pictureIds});

  static fromJson(Map<String, dynamic> json) {
    return Property(
        name: json['name'],
        userId: json['userId'],
        description: json['description'],
        street: json['street'],
        city: json['city'],
        zipCode: json['zipCode'],
        pictureIds: json['pictureIds'].cast<String>());
  }

  static Future<List<Property>> listProperties() async {
    List<Property> properties = [];
    var result = await ApiClient.database
        .listDocuments(databaseId: DB_ID, collectionId: COLLECTION_ID);

    properties
        .addAll(result.documents.map((doc) => Property.fromJson(doc.data)));

    return properties;
  }
}
