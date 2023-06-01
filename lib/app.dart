import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mta_app/const/l10n/s.dart';
import 'package:mta_app/core/global_navigator.dart';
import 'package:mta_app/core/locator/locator.dart';
import 'package:mta_app/features/auth/bloc/auth_bloc.dart';
import 'package:mta_app/features/auth/bloc/auth_event.dart';
import 'package:mta_app/features/auth/view/login.dart';
import 'package:mta_app/features/auth/view/signin.dart';
import 'package:mta_app/features/create_event/bloc/create_event_bloc.dart';
import 'package:mta_app/features/create_event/view/create_event.dart';
import 'package:mta_app/features/edit_event/bloc/edit_event_bloc.dart';
import 'package:mta_app/features/edit_event/view/edit_event.dart';
import 'package:mta_app/features/main/bloc/main_bloc.dart';
import 'package:mta_app/features/main/view/main_page.dart';
import 'package:mta_app/features/manage_users/bloc/manage_users_bloc.dart';
import 'package:mta_app/features/manage_users/view/manage_users_page.dart';
import 'package:mta_app/features/notfound/notfound_page.dart';
import 'package:mta_app/features/view_event/bloc/event_bloc.dart';
import 'package:mta_app/features/view_event/view/event.dart';

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
    return MultiBlocProvider(
        providers: [
          BlocProvider<ManageUsersBloc>(create: (context) => locator.get()),
          BlocProvider<CreateEventBloc>(create: (context) => locator.get()),
          BlocProvider<MainBloc>(create: (context) => locator.get()),
          BlocProvider<EventBloc>(create: (context) => locator.get()),
          BlocProvider<EditEventBlock>(
              create: (context) =>
                  locator.get()..add(EditEventEvent.selectTour(tour: 1))),
          BlocProvider<AuthBloc>(
              create: (context) =>
                  locator.get()..add(const AuthEvent.initial()))
        ],
        child: MaterialApp(
          builder: EasyLoading.init(),
          navigatorKey: _navigatorKey,
          debugShowCheckedModeBanner: false,
          initialRoute: LoginPage.routeName,
          routes: <String, WidgetBuilder>{
            MainPage.routeName: (context) => const MainPage(),
            LoginPage.routeName: (context) => const LoginPage(),
            SignInPage.routeName: (context) => const SignInPage(),
            CreateEvent.routeName: (context) => const CreateEvent(),
            EventPage.routeName: (context) => const EventPage(),
            EditEventPage.routeName: (context) => const EditEventPage(),
            ManageUsersPage.routeName: (context) => const ManageUsersPage()
          },
          onUnknownRoute: (rs) =>
              MaterialPageRoute(builder: (context) => const NotFoundPage()),
          localizationsDelegates: S.localizationsDelegates,
          supportedLocales: const [Locale('en')],
          theme: ThemeData(primaryColor: Colors.grey[800]),
        ));
  }
}
