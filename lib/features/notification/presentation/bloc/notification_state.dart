import '../../data/model/notification_model.dart';

sealed class NotificationState {
  const NotificationState();
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationLoaded extends NotificationState {
  final NotificationModel notifications;
  const NotificationLoaded(this.notifications);
}

class NotificationFailure extends NotificationState {
  final String message;
  const NotificationFailure(this.message);
}
