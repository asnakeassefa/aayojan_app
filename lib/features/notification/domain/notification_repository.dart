import '../data/model/notification_model.dart';

abstract class NotificationRepository {
  Future<NotificationModel> getNotifications();
}
