import 'package:aayojan/features/my_event/data/model/sub_event_detail_model.dart';

import '../../../my_event/data/model/event_model.dart';
import '../../data/model/sub_event_guest_model.dart';

sealed class SubEventState {}

class SubEventInit extends SubEventState {}

class EventLoading extends SubEventState {}

class SubEventLoading extends SubEventState {}

class SubEventSuccess extends SubEventState {
  final String message;
  SubEventSuccess({required this.message});
}

class MyEventLoaded extends SubEventState {
  
  final EventModel myEvent;
  MyEventLoaded(this.myEvent);
}

class SubEventFailure extends SubEventState {
  final String message;
  SubEventFailure({required this.message});
}

class SubEventLoaded extends SubEventState {
  final SubEventDetailModel subEvent;
  SubEventLoaded(this.subEvent);
}


class SubEventGuestsLoaded extends SubEventState {
  final SubEventGuestModel subEventGuests;
  SubEventGuestsLoaded(this.subEventGuests);
}

class SubEventGuestLoading extends SubEventState {}