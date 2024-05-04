import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/features/chat/domain/models/conversation_model.dart';
import 'package:sixam_mart_store/features/chat/domain/models/message_model.dart';
import 'package:sixam_mart_store/features/notification/domain/models/notification_body_model.dart';

abstract class ChatServiceInterface {
  Future<ConversationsModel?> getConversationList(int offset);
  Future<ConversationsModel?> searchConversationList(String name);
  Future<MessageModel?> getMessages(int offset, int? userId, String userType, int? conversationID);
  Future<MessageModel?> sendMessage(String message, List<MultipartBody> images, int? conversationId, int? userId, String userType);
  List<MultipartBody> processMultipartBody(List<XFile> chatImage);
  Future<MessageModel?> processSendMessage(NotificationBody? notificationBody, List<MultipartBody> chatImage, String message, int? conversationId);
  Future<MessageModel?> processGetMessage(int offset, NotificationBody notificationBody, int? conversationID);
}