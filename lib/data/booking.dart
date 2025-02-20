import 'package:appwrite/appwrite.dart';
import 'package:bnbscout24/api/client.dart';
import 'package:bnbscout24/utils/snackbar_service.dart';

//TODO: move this into env?
final String BASE_URL = 'https://god-did.de';
final String PROJECT_ID = '6780ee1a896fed0b8da7';
final String DB_ID = '6780faa636107ddbb899';
//this is only valid for booking objects
final String COLLECTION_ID = '67a4f2cd96ff4e22d5f6';

class Booking {
  final String id;
  final String propertyId;
  final String userId;
  final String status;
  final DateTime startDate;
  final DateTime endDate;

  Booking(
      {required this.propertyId,
      required this.userId,
      required this.status,
      required this.startDate,
      required this.endDate,
      String? id})
      : id = id ?? ID.unique();

  static fromJson(Map<String, dynamic> json) {
    //TODO: add property object as additional attribute to booking object?
    return Booking(
        propertyId: json['propertyId']['\$id'],
        userId: json['userId'],
        status: json['status'],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        id: json['\$id']);
  }

  static Map<String, dynamic> toJson(Booking booking) {
    Map<String, dynamic> json = {};
    json['propertyId'] = booking.propertyId;
    json['userId'] = booking.userId;
    json['status'] = booking.status;
    json['startDate'] = booking.startDate.toString();
    json['endDate'] = booking.endDate.toString();
    return json;
  }

  //TODO: move the following functions out of class?
  //TODO: maybe make use of snackbar optional and return error object instead

  static Future<List<Booking>?> listBookings() async {
    try {
      List<Booking> bookings = [];
      var result = await ApiClient.database
          .listDocuments(databaseId: DB_ID, collectionId: COLLECTION_ID);

      bookings
          .addAll(result.documents.map((doc) => Booking.fromJson(doc.data)));

      return bookings;
    } catch (error) {
      if (error is AppwriteException) {
        SnackbarService.showError('${error.message} (${error.code})');
      }
      return null;
    }
  }

  static Future<Booking?> getBookingById(String bookingId) async {
    try {
      var result = await ApiClient.database.getDocument(
          databaseId: DB_ID,
          collectionId: COLLECTION_ID,
          documentId: bookingId);
      return Booking.fromJson(result.data);
    } catch (error) {
      if (error is AppwriteException) {
        SnackbarService.showError('${error.message} (${error.code})');
      }
      return null;
    }
  }

  static Future<Booking?> createBooking(Booking newBooking) async {
    try {
      var result = await ApiClient.database.createDocument(
          databaseId: DB_ID,
          collectionId: COLLECTION_ID,
          documentId: newBooking.id,
          data: Booking.toJson(newBooking));
      return Booking.fromJson(result.data);
    } catch (error) {
      if (error is AppwriteException) {
        SnackbarService.showError('${error.message} (${error.code})');
      }
      return null;
    }
  }

  static Future<Booking?> updateBooking(
    String bookingId, {
    String? propertyId,
    String? userId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      //TODO: optimize this
      var updateJson = {};
      if (propertyId != null) updateJson['propertyId'] = propertyId;
      if (userId != null) updateJson['userId'] = userId;
      if (status != null) updateJson['status'] = status;
      if (startDate != null) updateJson['startDate'] = startDate;
      if (endDate != null) updateJson['endDate'] = endDate;

      var result = await ApiClient.database.updateDocument(
          databaseId: DB_ID,
          collectionId: COLLECTION_ID,
          documentId: bookingId,
          data: updateJson);

      return Booking.fromJson(result.data);
    } catch (error) {
      if (error is AppwriteException) {
        SnackbarService.showError('${error.message} (${error.code})');
      }
      return null;
    }
  }

  static Future<bool> deleteBooking(String bookingId) async {
    try {
      //TODO: delete files associated with property
      await ApiClient.database.deleteDocument(
          databaseId: DB_ID,
          collectionId: COLLECTION_ID,
          documentId: bookingId);
      return true;
    } catch (error) {
      if (error is AppwriteException) {
        SnackbarService.showError('${error.message} (${error.code})');
      }
      return false;
    }
  }
}
