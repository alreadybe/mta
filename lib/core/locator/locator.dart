import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:mta_app/core/locator/locator.config.dart';

GetIt locator = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => locator.init();
