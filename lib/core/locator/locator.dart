import 'package:mta_app/core/locator/locator.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

GetIt locator = GetIt.instance;

@InjectableInit(
  preferRelativeImports: false,
)
Future<void> configureDependencies({required String platform}) => $initGetIt(
      locator,
      environment: platform,
    );
