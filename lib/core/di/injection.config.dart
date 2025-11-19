// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/data_source/remote_datasource.dart' as _i323;
import '../../features/auth/data/repository/auth_repository_impl.dart' as _i409;
import '../../features/auth/domain/auth_repository.dart' as _i996;
import '../../features/auth/presentation/bloc/auth_cubit.dart' as _i52;
import '../../features/guest/data/datasource/guest_data_source.dart' as _i972;
import '../../features/guest/data/repository/guest_repository_impl.dart'
    as _i696;
import '../../features/guest/domain/guest_repository.dart' as _i880;
import '../../features/guest/presentation/bloc/guest_cubit.dart' as _i830;
import '../../features/invitation/data/datasource/invitation_data_source.dart'
    as _i531;
import '../../features/invitation/data/repository/invitation_repository_impl.dart'
    as _i488;
import '../../features/invitation/domain/invitation_repository.dart' as _i635;
import '../../features/invitation/presentation/bloc/invitation_cubit.dart'
    as _i386;
import '../../features/manage_family/data/data_source/data_source.dart'
    as _i372;
import '../../features/manage_family/data/repository/family_repository_impl.dart'
    as _i44;
import '../../features/manage_family/domain/family_repository.dart' as _i952;
import '../../features/manage_family/presentation/bloc/family_cubit.dart'
    as _i872;
import '../../features/my_event/data/data_source/remote_data_source.dart'
    as _i378;
import '../../features/my_event/data/repository/event_repository_impl.dart'
    as _i944;
import '../../features/my_event/domain/event_repository.dart' as _i882;
import '../../features/my_event/presentation/bloc/my_event_cubit.dart' as _i502;
import '../../features/notification/data/datasource/remote_data_source.dart'
    as _i1041;
import '../../features/notification/data/repository/notification_repository_impl.dart'
    as _i341;
import '../../features/notification/domain/notification_repository.dart'
    as _i432;
import '../../features/notification/presentation/bloc/notification_cubit.dart'
    as _i824;
import '../../features/plan_event/data/datasource/event_data_source.dart'
    as _i252;
import '../../features/plan_event/data/repository/plan_event_repository_impl.dart'
    as _i672;
import '../../features/plan_event/domain/plan_event_repository.dart' as _i392;
import '../../features/plan_event/presentation/bloc/plan_event_cubit.dart'
    as _i955;
import '../../features/plan_sub_event/data/datasource/sub_event_data_source.dart'
    as _i344;
import '../../features/plan_sub_event/data/repository/plan_sub_event_repository_impl.dart'
    as _i583;
import '../../features/plan_sub_event/domain/plan_sub_event_repository.dart'
    as _i339;
import '../../features/plan_sub_event/presentation/bloc/sub_event_cubit.dart'
    as _i552;
import '../../features/profile/data/datasource/profile_data_source.dart'
    as _i986;
import '../../features/profile/data/repository/profile_repository_impl.dart'
    as _i309;
import '../../features/profile/domain/profile_repository.dart' as _i789;
import '../../features/profile/presentation/bloc/profile_cubit.dart' as _i800;
import '../network/check_internet.dart' as _i1072;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.factory<_i1072.CheckInternet>(() => _i1072.CheckInternet());
  gh.factory<_i986.ProfileDataSource>(() => _i986.ProfileDataSourceImpl());
  gh.factory<_i531.InvitationDataSource>(
      () => _i531.InvitationDataSourceImpl());
  gh.factory<_i372.FamilyDataSource>(() => _i372.FamilyDataSourceImpl());
  gh.factory<_i1041.NotificationDataSource>(
      () => _i1041.NotificationDataSourceImpl());
  gh.factory<_i252.EventDataSource>(() => _i252.EventDataSourceImpl());
  gh.factory<_i344.SubEventDataSource>(() => _i344.SubEventDataSourceImpl());
  gh.factory<_i392.PlanEventRepository>(
      () => _i672.PlanEventRepositoryImpl(gh<_i252.EventDataSource>()));
  gh.factory<_i339.PlanSubEventRepository>(
      () => _i583.PlanSubEventRepositoryImpl(gh<_i344.SubEventDataSource>()));
  gh.factory<_i378.EventRemoteDataSource>(() => _i378.RemoteDataSourceImpl());
  gh.factory<_i972.GuestDataSource>(() => _i972.GuestDataSourceImpl());
  gh.factory<_i323.AuthRemoteDataSource>(
      () => _i323.AuthRemoteDataSourceImpl());
  gh.factory<_i552.SubEventCubit>(
      () => _i552.SubEventCubit(gh<_i339.PlanSubEventRepository>()));
  gh.factory<_i882.EventRepository>(
      () => _i944.EventRepositoryImpl(gh<_i378.EventRemoteDataSource>()));
  gh.factory<_i635.InvitationRepository>(
      () => _i488.InvitationRepositoryImpl(gh<_i531.InvitationDataSource>()));
  gh.factory<_i789.ProfileRepository>(
      () => _i309.ProfileRepositoryImpl(gh<_i986.ProfileDataSource>()));
  gh.factory<_i386.InvitationCubit>(
      () => _i386.InvitationCubit(gh<_i635.InvitationRepository>()));
  gh.factory<_i432.NotificationRepository>(() =>
      _i341.NotificationRepositoryImpl(gh<_i1041.NotificationDataSource>()));
  gh.factory<_i952.FamilyRepository>(
      () => _i44.FamilyRepositoryImpl(gh<_i372.FamilyDataSource>()));
  gh.factory<_i996.AuthRepository>(() => _i409.AuthRepositoryImpl(
        authRemoteDataSource: gh<_i323.AuthRemoteDataSource>(),
        checkInternet: gh<_i1072.CheckInternet>(),
      ));
  gh.factory<_i955.PlanEventCubit>(
      () => _i955.PlanEventCubit(gh<_i392.PlanEventRepository>()));
  gh.factory<_i880.GuestRepository>(
      () => _i696.GuestRepositoryImpl(gh<_i972.GuestDataSource>()));
  gh.factory<_i502.MyEventCubit>(
      () => _i502.MyEventCubit(gh<_i882.EventRepository>()));
  gh.factory<_i872.FamilyCubit>(
      () => _i872.FamilyCubit(gh<_i952.FamilyRepository>()));
  gh.factory<_i800.ProfileCubit>(
      () => _i800.ProfileCubit(gh<_i789.ProfileRepository>()));
  gh.factory<_i824.NotificationCubit>(
      () => _i824.NotificationCubit(gh<_i432.NotificationRepository>()));
  gh.factory<_i52.AuthCubit>(() => _i52.AuthCubit(gh<_i996.AuthRepository>()));
  gh.factory<_i830.GuestCubit>(
      () => _i830.GuestCubit(gh<_i880.GuestRepository>()));
  return getIt;
}
