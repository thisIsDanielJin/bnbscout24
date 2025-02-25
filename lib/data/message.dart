import 'package:appwrite/appwrite.dart';
import 'package:bnbscout24/api/client.dart';
import 'package:bnbscout24/utils/snackbar_service.dart';

//TODO: move this into env?
final String BASE_URL = 'https://god-did.de';
final String PROJECT_ID = '6780ee1a896fed0b8da7';
final String DB_ID = '6780faa636107ddbb899';
//this is only valid for message objects
final String COLLECTION_ID = '67bc7759468571ae5750';

class Message {
  final String id;
  final String propertyId;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime created;

  Message(
      {required this.propertyId,
      required this.senderId,
      required this.receiverId,
      required this.message,
      required this.created,
      String? id})
      : id = id ?? ID.unique();

  static fromJson(Map<String, dynamic> json, DateTime created) {
    return Message(
        propertyId: json['propertyId']['\$id'],
        senderId: json['senderId'],
        receiverId: json['receiverId'],
        message: json['message'],
        created: created,
        id: json['\$id']);
  }

  static Map<String, dynamic> toJson(Message message) {
    Map<String, dynamic> json = {};
    json['propertyId'] = message.propertyId;
    json['senderId'] = message.senderId;
    json['receiverId'] = message.receiverId;
    json['message'] = message.message;
    return json;
  }

  //TODO: move the following functions out of class?
  //TODO: maybe make use of snackbar optional and return error object instead

  static RealtimeSubscription subscribeMessages() {
    return Realtime(ApiClient.database.client).subscribe(
        ["databases.${DB_ID}.collections.${COLLECTION_ID}.documents"]);
  }

  static Future<List<Message>?> listMessages(
      {String? userId, String? propertyId}) async {
    try {
      List<Message> messages = [];

      List<String> senderQuery = [
        Query.equal("senderId", [userId])
      ];
      if (propertyId != null) {
        senderQuery.add(Query.equal("propertyId", propertyId));
      }
      var result = await ApiClient.database.listDocuments(
          databaseId: DB_ID, collectionId: COLLECTION_ID, queries: senderQuery);
      messages.addAll(result.documents.map(
          (doc) => Message.fromJson(doc.data, DateTime.parse(doc.$createdAt))));

      List<String> receiverQuery = [
        Query.equal("receiverId", [userId])
      ];
      if (propertyId != null) {
        senderQuery.add(Query.equal("propertyId", propertyId));
      }
      var result2 = await ApiClient.database.listDocuments(
          databaseId: DB_ID,
          collectionId: COLLECTION_ID,
          queries: receiverQuery);
      messages.addAll(result2.documents.map(
          (doc) => Message.fromJson(doc.data, DateTime.parse(doc.$createdAt))));

      // Manually filter bc appearenty it is not supported by appwrite to query releations...
      if (propertyId != null) {
        messages =
            messages.where((msg) => msg.propertyId == propertyId).toList();
      }
      messages.sort((msg1, msg2) => msg1.created.compareTo(msg2.created));

      return messages;
    } catch (error) {
      if (error is AppwriteException) {
        SnackbarService.showError('${error.message} (${error.code})');
      }
      return null;
    }
  }

  static Future<Message?> getBookingById(String messageId) async {
    try {
      var result = await ApiClient.database.getDocument(
          databaseId: DB_ID,
          collectionId: COLLECTION_ID,
          documentId: messageId);
      return Message.fromJson(result.data, DateTime.parse(result.$createdAt));
    } catch (error) {
      if (error is AppwriteException) {
        SnackbarService.showError('${error.message} (${error.code})');
      }
      return null;
    }
  }

  static Future<Message?> createMessage(Message newMessage) async {
    try {
      var result = await ApiClient.database.createDocument(
          databaseId: DB_ID,
          collectionId: COLLECTION_ID,
          documentId: newMessage.id,
          data: Message.toJson(newMessage));
      return Message.fromJson(result.data, DateTime.parse(result.$createdAt));
    } catch (error) {
      if (error is AppwriteException) {
        SnackbarService.showError('${error.message} (${error.code})');
      }
      return null;
    }
  }

  static Future<Message?> updateBooking(String messageId,
      {String? propertyId,
      String? senderId,
      String? receiverId,
      String? message}) async {
    try {
      //TODO: optimize this
      var updateJson = {};
      if (propertyId != null) updateJson['propertyId'] = propertyId;
      if (senderId != null) updateJson['senderId'] = senderId;
      if (receiverId != null) updateJson['receiverId'] = receiverId;

      if (message != null) updateJson['message'] = message;

      var result = await ApiClient.database.updateDocument(
          databaseId: DB_ID,
          collectionId: COLLECTION_ID,
          documentId: messageId,
          data: updateJson);

      return Message.fromJson(result.data, DateTime.parse(result.$createdAt));
    } catch (error) {
      if (error is AppwriteException) {
        SnackbarService.showError('${error.message} (${error.code})');
      }
      return null;
    }
  }

  static Future<bool> deleteBooking(String messageId) async {
    try {
      //TODO: delete files associated with property
      await ApiClient.database.deleteDocument(
          databaseId: DB_ID,
          collectionId: COLLECTION_ID,
          documentId: messageId);
      return true;
    } catch (error) {
      if (error is AppwriteException) {
        SnackbarService.showError('${error.message} (${error.code})');
      }
      return false;
    }
  }
}
