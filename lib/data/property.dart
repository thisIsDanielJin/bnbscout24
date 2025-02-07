import 'package:appwrite/appwrite.dart';
import 'package:bnbscout24/api/client.dart';

final String DB_ID = '6780faa636107ddbb899';
final String COLLECTION_ID = '6780fb97607609a113df';

class Property {
  final String id;
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
      required this.pictureIds,
      String? id})
      : id = id ?? ID.unique();

  static fromJson(Map<String, dynamic> json) {
    return Property(
        name: json['name'],
        userId: json['userId'],
        description: json['description'],
        street: json['street'],
        city: json['city'],
        zipCode: json['zipCode'],
        pictureIds: json['pictureIds'].cast<String>(),
        id: json['\$id']);
  }

  static Map<String, dynamic> toJson(Property property) {
    Map<String, dynamic> json = {};
    json['name'] = property.name;
    json['userId'] = property.userId;
    json['description'] = property.description;
    json['street'] = property.street;
    json['city'] = property.city;
    json['zipCode'] = property.zipCode;
    json['pictureIds'] = property.pictureIds;
    return json;
  }

  //TODO: move the following functions out of class?

  static Future<List<Property>> listProperties() async {
    List<Property> properties = [];
    var result = await ApiClient.database
        .listDocuments(databaseId: DB_ID, collectionId: COLLECTION_ID);

    properties
        .addAll(result.documents.map((doc) => Property.fromJson(doc.data)));

    return properties;
  }

  static Future<Property> getPropertyById(String propertyId) async {
    var result = await ApiClient.database.getDocument(
        databaseId: DB_ID, collectionId: COLLECTION_ID, documentId: propertyId);

    return Property.fromJson(result.data);
  }

  static Future<Property> createProperty(Property newProperty) async {
    var result = await ApiClient.database.createDocument(
        databaseId: DB_ID,
        collectionId: COLLECTION_ID,
        documentId: newProperty.id,
        data: Property.toJson(newProperty));

    // TODO: what happens if request isn't successful? -> catch error and show snackbar?
    return Property.fromJson(result.data);
  }

  static Future<Property> updateProperty(
    String propertyId, {
    String? name,
    String? userId,
    String? description,
    String? street,
    String? city,
    int? zipCode,
    List<String>? pictureIds,
  }) async {
    //TODO: optimize this
    var updateJson = {};
    if (name != null) updateJson['name'] = name;
    if (userId != null) updateJson['userId'] = userId;
    if (description != null) updateJson['description'] = description;
    if (street != null) updateJson['street'] = street;
    if (city != null) updateJson['city'] = city;
    if (zipCode != null) updateJson['zipCode'] = zipCode;
    if (pictureIds != null) updateJson['pictureIds'] = pictureIds;

    var result = await ApiClient.database.updateDocument(
        databaseId: DB_ID,
        collectionId: COLLECTION_ID,
        documentId: propertyId,
        data: updateJson);

    return Property.fromJson(result.data);
  }

  static void deleteProperty(String propertyId) async {
    var result = await ApiClient.database.deleteDocument(
        databaseId: DB_ID, collectionId: COLLECTION_ID, documentId: propertyId);
  }
}
