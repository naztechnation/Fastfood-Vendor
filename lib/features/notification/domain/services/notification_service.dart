import 'package:sixam_mart_store/features/notification/domain/models/notification_model.dart';
import 'package:sixam_mart_store/features/notification/domain/repositories/notification_repository_interface.dart';
import 'package:sixam_mart_store/features/notification/domain/services/notification_service_interface.dart';

class NotificationService implements NotificationServiceInterface {
  final NotificationRepositoryInterface notificationRepositoryInterface;
  NotificationService({required this.notificationRepositoryInterface});

  @override
  Future<List<NotificationModel>?> getNotificationList() async {
    return await notificationRepositoryInterface.getList();
  }

  @override
  void saveSeenNotificationCount(int count) {
    notificationRepositoryInterface.saveSeenNotificationCount(count);
  }

  @override
  int? getSeenNotificationCount() {
    return notificationRepositoryInterface.getSeenNotificationCount();
  }

}