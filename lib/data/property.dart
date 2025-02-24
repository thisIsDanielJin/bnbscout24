import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:bnbscout24/api/client.dart';
import 'package:bnbscout24/utils/snackbar_service.dart';

//TODO: move this into env?
final String BASE_URL = 'https://god-did.de';
final String PROJECT_ID = '6780ee1a896fed0b8da7';
final String DB_ID = '6780faa636107ddbb899';
//these are only valid for property objects/files
final String COLLECTION_ID = '6780fb97607609a113df';
final String BUCKET_ID = '67a5d2f8f0ec7c4b941c';

class Property {
  final String id;
  final String name;
  final String userId;
  final String description;
  final String address;
  final double geoLat;
  final double geoLon;
  final List<String>? pictureIds;
  final String priceInterval;
  final int priceIntervalCents;
  final double squareMetres;
  final int roomAmount;
  final double? mbitPerSecond;


  Property(
      {required this.name,
      required this.userId,
      required this.description,
      required this.address,
      this.pictureIds,
      required this.priceInterval,
      required this.priceIntervalCents,
      required this.squareMetres,
      required this.roomAmount,
      this.mbitPerSecond,
      required this.geoLat,
      required this.geoLon,
      String? id})
      : id = id ?? ID.unique();

  static fromJson(Map<String, dynamic> json) {
    return Property(
        name: json['name'],
        userId: json['userId'],
        description: json['description'] ?? "",
        address: json['address'],
        pictureIds: json['pictureIds'].cast<String>(),
        priceInterval: json['priceInterval'],
        priceIntervalCents: json['priceIntervalCents'],
        squareMetres: json['squareMetres'],
        roomAmount: json['roomAmount'],
        mbitPerSecond: json['mbitPerSecond'],
        geoLat: json['geoLat'],
        geoLon: json['geoLon'],
        id: json['\$id']);
        
  }

  static Map<String, dynamic> toJson(Property property) {
    Map<String, dynamic> json = {};
    json['name'] = property.name;
    json['userId'] = property.userId;
    json['description'] = property.description;
    json['address'] = property.address;
    json['pictureIds'] = property.pictureIds;
    json['priceInterval'] = property.priceInterval;
    json['priceIntervalCents'] = property.priceIntervalCents;
    
    json['squareMetres'] = property.squareMetres;
    json['roomAmount'] = property.roomAmount;
    json['mbitPerSecond'] = property.mbitPerSecond;
    json['geoLat'] = property.geoLat;
    json['geoLon'] = property.geoLon;
    return json;
  }

  static List<String>? generateImageUrls(Property property) {
    return property.pictureIds
        ?.map((id) =>
            "$BASE_URL/v1/storage/buckets/$BUCKET_ID/files/$id/view?project=$PROJECT_ID")
        .toList();
  }

  //TODO: test this and adapt if necessary. not sure if it works.
  //TODO: decide if InputFile.fromPath or InputFile.fromBytes is supposed to be used
  static Future<String?> uploadImage(List<int> bytes, String filename) async {
    try {
      var result = await ApiClient.storage.createFile(
        bucketId: BUCKET_ID,
        fileId: ID.unique(),
        file: InputFile.fromBytes(bytes: bytes, filename: filename),
      );

      return result.$id;
    } catch (error) {
      if (error is AppwriteException) {
        SnackbarService.showError('${error.message} (${error.code})');
      }
      return null;
    }
  }

  //TODO: move the following functions out of class?
  //TODO: maybe make use of snackbar optional and return error object instead

  static Future<List<Property>?> listProperties() async {
    try {
      List<Property> properties = [];
      var result = await ApiClient.database
          .listDocuments(databaseId: DB_ID, collectionId: COLLECTION_ID);


      for (Document doc in result.documents) {
        try {
          properties.add(Property.fromJson(doc.data));
        }
        catch(e) {
          print("Error parsing doc");
          print(e);          
        }
      }

      print(properties.length);
      return properties;
    } catch (error) {
      if (error is AppwriteException) {
        SnackbarService.showError('${error.message} (${error.code})');
      }
      print(error);
      return null;
    }
  }

  static Future<Property?> getPropertyById(String propertyId) async {
    try {
      var result = await ApiClient.database.getDocument(
          databaseId: DB_ID,
          collectionId: COLLECTION_ID,
          documentId: propertyId);
      return Property.fromJson(result.data);
    } catch (error) {
      if (error is AppwriteException) {
        SnackbarService.showError('${error.message} (${error.code})');
      }
      return null;
    }
  }

  static Future<Property?> createProperty(Property newProperty) async {
    try {
      var result = await ApiClient.database.createDocument(
          databaseId: DB_ID,
          collectionId: COLLECTION_ID,
          documentId: newProperty.id,
          data: Property.toJson(newProperty));
      return Property.fromJson(result.data);
    } catch (error) {
      if (error is AppwriteException) {
        SnackbarService.showError('${error.message} (${error.code})');
      }
      return null;
    }
  }

  static Future<Property?> updateProperty(String propertyId,
      {String? name,
      String? userId,
      String? description,
      String? address,
      List<String>? pictureIds,
      double? rentPerDay,
      double? squareMetres,
      int? roomAmount,
      double? mbitPerSecond}) async {
    try {

      var updateJson = {};
      if (name != null) updateJson['name'] = name;
      if (userId != null) updateJson['userId'] = userId;
      if (address != null) updateJson['address'] = address;
      if (description != null) updateJson['description'] = description;
      if (pictureIds != null) updateJson['pictureIds'] = pictureIds;
      if (rentPerDay != null) updateJson['rentPerDay'] = rentPerDay;
      if (squareMetres != null) updateJson['squareMetres'] = squareMetres;
      if (roomAmount != null) updateJson['roomAmount'] = roomAmount;
      if (mbitPerSecond != null) updateJson['mbitPerSecond'] = mbitPerSecond;

      var result = await ApiClient.database.updateDocument(
          databaseId: DB_ID,
          collectionId: COLLECTION_ID,
          documentId: propertyId,
          data: updateJson);

      return Property.fromJson(result.data);
    } catch (error) {
      if (error is AppwriteException) {
        SnackbarService.showError('${error.message} (${error.code})');
      }
      return null;
    }
  }

  static Future<bool> deleteProperty(String propertyId) async {
    try {
      //TODO: delete files associated with property
      await ApiClient.database.deleteDocument(
          databaseId: DB_ID,
          collectionId: COLLECTION_ID,
          documentId: propertyId);
      return true;
    } catch (error) {
      if (error is AppwriteException) {
        SnackbarService.showError('${error.message} (${error.code})');
      }
      return false;
    }
  }
}
