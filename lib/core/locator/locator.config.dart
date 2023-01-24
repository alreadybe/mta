// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logger/logger.dart' as _i6;
import 'package:mta_app/core/global_navigator.dart' as _i5;
import 'package:mta_app/core/locator/modules/logger_module.dart' as _i10;
import 'package:mta_app/core/locator/modules/shared_preferences_module.dart'
    as _i11;
import 'package:mta_app/core/logger.dart' as _i9;
import 'package:mta_app/features/auth/bloc/auth_bloc.dart' as _i3;
import 'package:mta_app/features/create_event/bloc/create_event_bloc.dart'
    as _i4;
import 'package:mta_app/features/main/bloc/main_bloc.dart' as _i7;
import 'package:shared_preferences/shared_preferences.dart'
    as _i8; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final loggerModule = _$LoggerModule();
  final sharedPreferencesModule = _$SharedPreferencesModule();
  gh.factory<_i3.AuthBloc>(() => _i3.AuthBloc());
  gh.factory<_i4.CreateEventBloc>(() => _i4.CreateEventBloc());
  gh.singleton<_i5.GlobalNavigator>(_i5.GlobalNavigator());
  gh.factory<_i6.LogPrinter>(() => loggerModule.logPrinter);
  gh.factory<_i7.MainBloc>(() => _i7.MainBloc());
  await gh.factoryAsync<_i8.SharedPreferences>(
    () => sharedPreferencesModule.sharedPreferences,
    preResolve: true,
  );
  gh.factory<_i9.CustomPrinter>(() => _i9.CustomPrinter(get<_i6.LogPrinter>()));
  gh.singleton<_i6.Logger>(loggerModule.logger(get<_i9.CustomPrinter>()));
  return get;
}

class _$LoggerModule extends _i10.LoggerModule {}

class _$SharedPreferencesModule extends _i11.SharedPreferencesModule {}
