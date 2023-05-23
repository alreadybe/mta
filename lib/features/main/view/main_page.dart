import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mta_app/features/auth/bloc/auth_bloc.dart';
import 'package:mta_app/features/auth/bloc/auth_event.dart';
import 'package:mta_app/features/auth/bloc/auth_state.dart';
import 'package:mta_app/features/auth/view/login.dart';
import 'package:mta_app/features/create_event/view/create_event.dart';
import 'package:mta_app/features/main/bloc/main_bloc.dart';
import 'package:mta_app/features/main/widgets/event_item.dart';
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

  @override
  void initState() {
    super.initState();
    _mainBloc = context.read();
    _authBloc = context.read();
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
                floatingActionButton:
                    authState.mapOrNull(authenticated: (value) {
                  if (value.user.userType.contains(UserType.ORG) ||
                      value.user.userType.contains(UserType.ADMIN)) {
                    return FloatingActionButton(
                      child: const Icon(Icons.add),
                      onPressed: () =>
                          Navigator.pushNamed(context, CreateEvent.routeName),
                    );
                  }
                  return null;
                }),
                appBar: AppBar(
                  centerTitle: true,
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, LoginPage.routeName, (route) => false);
                          _authBloc.add(const AuthEvent.logout());
                        },
                        icon: const Icon(Icons.logout))
                  ],
                  title: const Text('Pairing app'),
                ),
                body: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: mainState.mapOrNull(
                          loaded: (value) => ListView.builder(
                            itemCount: value.events.length,
                            itemBuilder: (context, index) =>
                                EventItem(event: value.events[index]),
                          ),
                        ) ??
                        const Center(child: CircularProgressIndicator())),
              ),
            );
          },
        );
      },
    );
  }
}
