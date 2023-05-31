// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:mta_app/core/global_navigator.dart' as _i7;
import 'package:mta_app/core/locator/modules/shared_preferences_module.dart'
    as _i10;
import 'package:mta_app/features/auth/bloc/auth_bloc.dart' as _i3;
import 'package:mta_app/features/create_event/bloc/create_event_bloc.dart'
    as _i4;
import 'package:mta_app/features/edit_event/bloc/edit_event_bloc.dart' as _i5;
import 'package:mta_app/features/main/bloc/main_bloc.dart' as _i8;
import 'package:mta_app/features/view_event/bloc/event_bloc.dart' as _i6;
import 'package:shared_preferences/shared_preferences.dart' as _i9;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final sharedPreferencesModule = _$SharedPreferencesModule();
    gh.factory<_i3.AuthBloc>(() => _i3.AuthBloc());
    gh.factory<_i4.CreateEventBloc>(() => _i4.CreateEventBloc());
    gh.factory<_i5.EditEventBlock>(() => _i5.EditEventBlock());
    gh.factory<_i6.EventBloc>(() => _i6.EventBloc());
    gh.singleton<_i7.GlobalNavigator>(_i7.GlobalNavigator());
    gh.factory<_i8.MainBloc>(() => _i8.MainBloc());
    await gh.factoryAsync<_i9.SharedPreferences>(
      () => sharedPreferencesModule.sharedPreferences,
      preResolve: true,
    );
    return this;
  }
}

class _$SharedPreferencesModule extends _i10.SharedPreferencesModule {}
