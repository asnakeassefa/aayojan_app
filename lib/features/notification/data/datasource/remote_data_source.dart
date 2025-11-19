import 'package:aayojan/core/network/api_provider.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/endpoints.dart';
import '../model/notification_model.dart';

abstract class NotificationDataSource {
  Future<NotificationModel> getNotifications();
}

@Injectable(as: NotificationDataSource)
class NotificationDataSourceImpl implements NotificationDataSource {
  ApiService api = ApiService();
  @override
  Future<NotificationModel> getNotifications() async {
    try {
      final response = await api.get(Endpoints.getNotification);
      return NotificationModel.fromJson(response.data);
    } catch (e) {
      if (e is ClientException) {
        rethrow;
      } else if (e is ServerException) {
        rethrow;
      } else {
        throw 'Something went wrong';
      }
    }
  }
}
