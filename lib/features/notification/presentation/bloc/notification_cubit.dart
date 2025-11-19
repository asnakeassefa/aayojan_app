import 'package:aayojan/features/notification/domain/notification_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'notification_state.dart';

@injectable
class NotificationCubit extends Cubit<NotificationState> {
  NotificationRepository repository;
  NotificationCubit(
    this.repository,
  ) : super(const NotificationInitial());

  void getNotifications() async {
    try {
      emit(const NotificationLoading());
      final response = await repository.getNotifications();
      emit(NotificationLoaded(response));
    } catch (e) {
      emit(NotificationFailure(e.toString()));
    }
  }
}
