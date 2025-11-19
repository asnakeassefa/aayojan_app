import 'package:aayojan/features/notification/data/model/notification_model.dart';
import 'package:injectable/injectable.dart';

import '../../domain/notification_repository.dart';
import '../datasource/remote_data_source.dart';

@Injectable(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  NotificationDataSource dataSource;
  NotificationRepositoryImpl(this.dataSource);
  @override
  Future<NotificationModel> getNotifications() async {
    try {
      return await dataSource.getNotifications();
    } catch (e) {
      rethrow;
    }
  }
}
