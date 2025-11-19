import 'package:aayojan/features/my_event/data/model/event_model.dart';
import 'package:aayojan/features/my_event/data/model/sub_event_model.dart';

sealed class MyEventState {}

class MyEventInit extends MyEventState {}

class MyeventLoading extends MyEventState {}

class MyEventLoaded extends MyEventState {
  final EventModel response;
  MyEventLoaded(this.response);
}

class MySubEventLoaded extends MyEventState {
  final SubEventModel response;
  MySubEventLoaded(this.response);
}

class MyEventUpdated extends MyEventState {
  final String message;
  MyEventUpdated(this.message);
}

class MyEventDeleted extends MyEventState {
  final String message;
  MyEventDeleted(this.message);
}

class MySubEventDeleted extends MyEventState {
  final String message;
  MySubEventDeleted(this.message);
}

class MyEventFailure extends MyEventState {
  final String message;
  MyEventFailure(this.message);
}
