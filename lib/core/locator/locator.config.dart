// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logger/logger.dart' as _i5;
import 'package:mta_app/core/global_navigator.dart' as _i4;
import 'package:mta_app/core/locator/modules/logger_module.dart' as _i9;
import 'package:mta_app/core/locator/modules/shared_preferences_module.dart' as _i10;
import 'package:mta_app/core/logger.dart' as _i7;
import 'package:shared_preferences/shared_preferences.dart'
    as _i6; // ignore_for_file: unnecessary_lambdas

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
  gh.singleton<_i4.GlobalNavigator>(_i4.GlobalNavigator());
  gh.factory<_i5.LogPrinter>(() => loggerModule.logPrinter);
  await gh.factoryAsync<_i6.SharedPreferences>(
    () => sharedPreferencesModule.sharedPreferences,
    preResolve: true,
  );
  gh.factory<_i7.CustomPrinter>(() => _i7.CustomPrinter(get<_i5.LogPrinter>()));
  gh.singleton<_i5.Logger>(loggerModule.logger(get<_i7.CustomPrinter>()));
  return get;
}

class _$LoggerModule extends _i9.LoggerModule {}

class _$SharedPreferencesModule extends _i10.SharedPreferencesModule {}
