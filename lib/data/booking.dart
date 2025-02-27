import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:bnbscout24/api/client.dart';
import 'package:bnbscout24/utils/snackbar_service.dart';
import 'package:bnbscout24/constants/config.dart';

class Booking {
  final String id;
  final String propertyId;
  final String userId;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;

  Booking(
      {required this.propertyId,
      required this.userId,
      required this.status,
      required this.startDate,
      required this.endDate,
      String? id})
      : id = id ?? ID.unique();

  static Booking fromJson(Map<String, dynamic> json) {
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

  static RealtimeSubscription subsribeBookings() {
    return Realtime(ApiClient.database.client).subscribe([
      "databases.${Config.DB_ID}.collections.${Config.BOOKING_COLLECTION_ID}.documents"
    ]);
  }

  //TODO: move the following functions out of class?
  //TODO: maybe make use of snackbar optional and return error object instead

  static Future<List<Booking>?> listBookings() async {
    try {
      List<Booking> bookings = [];
      var result = await ApiClient.database.listDocuments(
          databaseId: Config.DB_ID, collectionId: Config.BOOKING_COLLECTION_ID);

      for (Document doc in result.documents) {
        try {
          bookings.add(Booking.fromJson(doc.data));
        } catch (e) {
          print("Error parsing booking ${e}");
        }
      }

      print(bookings);

      return bookings;
    } catch (error) {
      if (error is AppwriteException) {
        SnackbarService.showError('${error.message} (${error.code})');
      }
      print("ERROR");
      print(error);
      return null;
    }
  }

  static Future<Booking?> getBookingById(String bookingId) async {
    try {
      var result = await ApiClient.database.getDocument(
          databaseId: Config.DB_ID,
          collectionId: Config.BOOKING_COLLECTION_ID,
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
          databaseId: Config.DB_ID,
          collectionId: Config.BOOKING_COLLECTION_ID,
          documentId: newBooking.id,
          data: Booking.toJson(newBooking));
      return Booking.fromJson(result.data);
    } catch (error) {
      print(error);
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
      print(updateJson);
      var result = await ApiClient.database.updateDocument(
          databaseId: Config.DB_ID,
          collectionId: Config.BOOKING_COLLECTION_ID,
          documentId: bookingId,
          data: updateJson);

      return Booking.fromJson(result.data);
    } catch (error) {
      print(error);
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
          databaseId: Config.DB_ID,
          collectionId: Config.BOOKING_COLLECTION_ID,
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
