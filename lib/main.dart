import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mta_app/app.dart';
import 'package:mta_app/core/firebase_options.dart';
import 'package:mta_app/core/locator/locator.dart';
import 'package:mta_app/core/log.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependencies(platform: Platform.operatingSystem);
  await locator.allReady();
  runZonedGuarded(
    () => runApp(const App()),
    (error, stack) => log.wtf('Caught error in a guarded zone.', error, stack),
  );
}
