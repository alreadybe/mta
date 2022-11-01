import 'package:mta_app/const/l10n/s.dart';
import 'package:mta_app/core/global_navigator.dart';
import 'package:mta_app/core/locator/locator.dart';
import 'package:mta_app/features/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mta_app/features/notfound/notfound_page.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    locator.get<GlobalNavigator>().setNavigatorKey(_navigatorKey);
  }

  @override
  Widget build(BuildContext context) {
    return
        // MultiBlocProvider(
        //   providers: [
        //      BlocProvider<AuthBloc>(create: (context) => locator.get()),
        //   ],
        //   child:
        MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: MainPage.routeName,
      routes: <String, WidgetBuilder>{
        MainPage.routeName: (context) => const MainPage(),
      },
      onUnknownRoute: (rs) => MaterialPageRoute(builder: (context) => const NotFoundPage()),
      localizationsDelegates: S.localizationsDelegates,
      supportedLocales: const [Locale('en')],
    )
        // )
        ;
  }
}
