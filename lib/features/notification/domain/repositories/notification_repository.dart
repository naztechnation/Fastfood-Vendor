import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/features/notification/domain/models/notification_model.dart';
import 'package:sixam_mart_store/features/notification/domain/repositories/notification_repository_interface.dart';
import 'package:sixam_mart_store/util/app_constants.dart';

class NotificationRepository implements NotificationRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  NotificationRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<List<NotificationModel>?> getList() async {
    List<NotificationModel>? notificationList;
    Response response = await apiClient.getData(AppConstants.notificationUri);
    if(response.statusCode == 200){
      notificationList = [];
      response.body.forEach((notify) {
        NotificationModel notification = NotificationModel.fromJson(notify);
        notification.title = notify['data']['title'];
        notification.description = notify['data']['description'].toString();
        notification.image = notify['data']['image'];
        notificationList!.add(notification);
      });
    }
    return notificationList;
  }

  @override
  void saveSeenNotificationCount(int count) {
    sharedPreferences.setInt(AppConstants.notificationCount, count);
  }

  @override
  int? getSeenNotificationCount() {
    return sharedPreferences.getInt(AppConstants.notificationCount);
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(int? id) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}