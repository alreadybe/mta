import 'package:flutter/material.dart';

import 'package:mta_app/const/assets/assets.gen.dart';
import 'package:mta_app/core/locator/modules/storage.dart';
import 'package:mta_app/features/auth/view/login.dart';
import 'package:mta_app/features/main/view/main_page.dart';

class SplashPage extends StatefulWidget {
  static const routeName = 'splash';

  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const _transitionDuration = Duration(seconds: 1);
  late bool isLoggedIn;

  @override
  void initState() {
    super.initState();
    Storage().getUser().then((value) {
      if (value != null) {
        isLoggedIn = true;
      } else {
        isLoggedIn = false;
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future<void>.delayed(_transitionDuration)
          .then((value) => _nextScreen(isLoggedIn));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ColoredBox(
      color: Colors.cyan,
      child: Center(child: Image.asset(Assets.warhammerLogo.path)),
    ));
  }

  void _nextScreen(bool isLoggedIn) {
    if (!isLoggedIn) {
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
      return;
    }

    Navigator.pushReplacementNamed(context, MainPage.routeName);
  }
}
