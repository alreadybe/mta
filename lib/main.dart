import 'dart:async';
import 'dart:io';

import 'package:mta_app/app.dart';
import 'package:mta_app/core/locator/locator.dart';
import 'package:mta_app/core/log.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(platform: Platform.operatingSystem);
  await locator.allReady();
  runZonedGuarded(
    () => runApp(const App()),
    (error, stack) => log.wtf('Caught error in a guarded zone.', error, stack),
  );
}
