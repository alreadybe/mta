import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mta_app/app.dart';
import 'package:mta_app/core/firebase_options.dart';
import 'package:mta_app/core/locator/locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependencies(platform: Platform.operatingSystem);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.grey[900],
    statusBarColor: Colors.grey[900],
  ));
  await locator.allReady();
  runZoned(() => runApp(const App()));
}
