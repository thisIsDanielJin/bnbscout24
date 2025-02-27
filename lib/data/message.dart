import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:bnbscout24/api/client.dart';
import 'package:bnbscout24/utils/snackbar_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bnbscout24/constants/config.dart';

class MessageConversation {
  String chatPartnerId;
  String propertyId;
  List<Message> messages;
  bool isNew;

  MessageConversation(
      {required this.chatPartnerId,
      required this.propertyId,
      required this.messages,
      required this.isNew});
}

class Message {
  final String id;
  final String propertyId;
  final String senderId;
  final String receiverId;
  final String message;
  final bool isRead;
  final DateTime created;

  Message(
      {required this.propertyId,
      required this.senderId,
      required this.receiverId,
      required this.isRead,
      required this.message,
      required this.created,
      String? id})
      : id = id ?? ID.unique();


  static Message fromJson(Map<String, dynamic> json, DateTime created) {
    return Message(
        propertyId: json['propertyId']['\$id'],
        senderId: json['senderId'],
        receiverId: json['receiverId'],
        message: json['message'],
        isRead: json['isRead'],
        created: created,
        id: json['\$id']);
  }

  static Map<String, dynamic> toJson(Message message) {
    Map<String, dynamic> json = {};
    json['propertyId'] = message.propertyId;
    json['senderId'] = message.senderId;
    json['receiverId'] = message.receiverId;
    json['message'] = message.message;
    json['isRead'] = message.isRead;
    return json;
  }

  //TODO: move the following functions out of class?
  //TODO: maybe make use of snackbar optional and return error object instead

  static RealtimeSubscription subscribeMessages() {
    return Realtime(ApiClient.database.client).subscribe([
      "databases.${Config.DB_ID}.collections.${Config.MESSAGE_COLLECTION_ID}.documents"
    ]);
  }

  static void parseMessagesToConvos(
      List<Document> documents,
      List<MessageConversation> conversations,
      String? propertyId,
      String? partnerId,
      String Function(Message) getChatPartnerId) {
    for (Document doc in documents) {
      Message message =
          Message.fromJson(doc.data, DateTime.parse(doc.$createdAt));
      if ((propertyId != null && message.propertyId != propertyId) ||
          (partnerId != null && getChatPartnerId(message) != partnerId)) {
        continue;
      }
      MessageConversation? findConversation = conversations
          .where((conv) =>
              conv.chatPartnerId == getChatPartnerId(message) &&
              conv.propertyId == message.propertyId)
          .firstOrNull;
      if (findConversation == null) {
        findConversation = MessageConversation(
            chatPartnerId: getChatPartnerId(message),
            propertyId: message.propertyId,
            messages: [],
            isNew: true);
        conversations.add(findConversation);
      }
      findConversation.messages.add(message);
    }
  }

  static String KEY_MESSAGE_READ_IDS = "MESSAGE_READ_IDS";
  // Returns a map with chat partner keys
  static Future<List<MessageConversation>?> listMessageConverstations(
      {String? userId, String? partnerId, String? propertyId}) async {
    try {
      List<MessageConversation> conversations = [];

      var result = await ApiClient.database.listDocuments(
          databaseId: Config.DB_ID,
          collectionId: Config.MESSAGE_COLLECTION_ID,
          queries: [
            Query.equal("senderId", [userId])
          ]);
      print(result.documents.length);
      parseMessagesToConvos(result.documents, conversations, propertyId,
          partnerId, (msg) => msg.receiverId);
      print(conversations.length);

      var result2 = await ApiClient.database.listDocuments(
          databaseId: Config.DB_ID,
          collectionId: Config.MESSAGE_COLLECTION_ID,
          queries: [
            Query.equal("receiverId", [userId])
          ]);
      parseMessagesToConvos(result2.documents, conversations, propertyId,
          partnerId, (msg) => msg.senderId);

      for (var convo in conversations) {
        convo.messages
            .sort((msg1, msg2) => msg1.created.compareTo(msg2.created));

        convo.isNew = convo.messages.any((msg) => msg.receiverId == userId && !msg.isRead);
      }

      return conversations;
    } catch (error) {
      if (error is AppwriteException) {
        SnackbarService.showError('${error.message} (${error.code})');
      }
      return null;
    }
  }

  static Future<Message?> getMessageById(String messageId) async {
    try {
      var result = await ApiClient.database.getDocument(
          databaseId: Config.DB_ID,
          collectionId: Config.MESSAGE_COLLECTION_ID,
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
          databaseId: Config.DB_ID,
          collectionId: Config.MESSAGE_COLLECTION_ID,
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

  static Future<Message?> updateMessage(String messageId,
      {String? propertyId,
      String? senderId,
      String? receiverId,
      String? message,
      bool? isRead}) async {
    try {
      //TODO: optimize this
      var updateJson = {};
      if (propertyId != null) updateJson['propertyId'] = propertyId;
      if (senderId != null) updateJson['senderId'] = senderId;
      if (receiverId != null) updateJson['receiverId'] = receiverId;
      if (isRead != null) updateJson['isRead'] = isRead;

      if (message != null) updateJson['message'] = message;

      var result = await ApiClient.database.updateDocument(
          databaseId: Config.DB_ID,
          collectionId: Config.MESSAGE_COLLECTION_ID,
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
          databaseId: Config.DB_ID,
          collectionId: Config.MESSAGE_COLLECTION_ID,
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
