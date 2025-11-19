import '../../data/model/event_detail_model.dart';

sealed class PlanEventState {}

class PlanEventInit extends PlanEventState {}

class PlanEventLoading extends PlanEventState {}

class PlanEventLoadingWithSubEvent extends PlanEventState {}

class PlanEventSuccess extends PlanEventState {
  final String message;
  PlanEventSuccess({required this.message});
}

class PlanEventSuccessWithSubEvent extends PlanEventState {
  final String message;
  final num id;
  PlanEventSuccessWithSubEvent({required this.message, required this.id});
}

class SubEventUpdateSuccess extends PlanEventState {
  final String message;
  final String id;
  SubEventUpdateSuccess({required this.message, required this.id});
}

class PlanEventFailure extends PlanEventState {
  final String message;
  PlanEventFailure({required this.message});
}

class EventLoading extends PlanEventState {}

class EventLoaded extends PlanEventState {
  final EventDetailModel event;
  EventLoaded(this.event);
}
