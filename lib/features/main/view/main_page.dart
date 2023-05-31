import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mta_app/core/theme/colors.dart';
import 'package:mta_app/core/theme/styles.dart';
import 'package:mta_app/features/auth/bloc/auth_bloc.dart';
import 'package:mta_app/features/auth/bloc/auth_event.dart';
import 'package:mta_app/features/auth/bloc/auth_state.dart';
import 'package:mta_app/features/auth/view/login.dart';
import 'package:mta_app/features/main/bloc/main_bloc.dart';
import 'package:mta_app/features/main/view/I_page.dart';
import 'package:mta_app/features/main/view/pages/elo.dart';
import 'package:mta_app/features/main/view/pages/event.dart';
import 'package:mta_app/features/main/view/pages/settings.dart';
import 'package:mta_app/features/main/view/pages/stats.dart';
import 'package:mta_app/models/user_type_model.dart';

class MainPage extends StatefulWidget {
  static const routeName = 'main';

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final MainBloc _mainBloc;
  late final AuthBloc _authBloc;

  int currentIndex = 0;

  List<IPage> pages = [
    const Event(),
    const Elo(),
    const Stats(),
    const Settings()
  ];

  @override
  void initState() {
    super.initState();
    _mainBloc = context.read();
    _authBloc = context.read();
  }

  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        state.mapOrNull(
            error: (value) => showAboutDialog(
                context: context,
                children: [Text(value.message ?? 'Unknow error')]));
      },
      builder: (context, mainState) {
        mainState.mapOrNull(
          initial: (value) => _mainBloc.add(MainEvent.getData(filter: {})),
        );
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: AppColors.dark,
                bottomNavigationBar: BottomNavigationBar(
                    selectedLabelStyle:
                        AppStyles.textStyle.copyWith(color: AppColors.white),
                    selectedIconTheme: IconThemeData(color: AppColors.cyan),
                    showSelectedLabels: false,
                    unselectedLabelStyle: AppStyles.textStyle,
                    selectedItemColor: AppColors.white,
                    backgroundColor: AppColors.lightDark,
                    unselectedItemColor: AppColors.white,
                    type: BottomNavigationBarType.fixed,
                    currentIndex: currentIndex,
                    onTap: onItemTapped,
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.event_outlined), label: 'Events'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.leaderboard), label: 'ELO'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.data_saver_off_sharp),
                          label: 'Stats'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.settings), label: 'Settings'),
                    ]),
                appBar: AppBar(
                  backgroundColor: AppColors.lightDark,
                  actions: [
                    authState.maybeMap(
                        authenticated: (value) =>
                            value.user.userType.contains(UserType.ADMIN)
                                ? IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.supervised_user_circle,
                                      color: AppColors.cyan,
                                    ),
                                  )
                                : const SizedBox(),
                        orElse: () => const SizedBox()),
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, LoginPage.routeName, (route) => false);
                          _authBloc.add(const AuthEvent.logout());
                        },
                        icon: Icon(
                          Icons.logout,
                          color: AppColors.cyan,
                        ))
                  ],
                  title: Text(
                    pages[currentIndex].pageHeader,
                    style: AppStyles.textStyle.copyWith(
                        color: AppColors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                body: pages[currentIndex],
              ),
            );
          },
        );
      },
    );
  }
}
