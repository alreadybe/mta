// ignore_for_file: avoid_implementing_value_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mta_app/core/theme/colors.dart';
import 'package:mta_app/features/auth/bloc/auth_bloc.dart';
import 'package:mta_app/features/auth/bloc/auth_state.dart';
import 'package:mta_app/features/create_event/view/create_event.dart';
import 'package:mta_app/features/main/bloc/main_bloc.dart';
import 'package:mta_app/features/main/view/I_page.dart';
import 'package:mta_app/features/main/widgets/event_item.dart';
import 'package:mta_app/models/user_type_model.dart';

class Event extends StatefulWidget implements IPage {
  static const header = 'Events';

  const Event({super.key});

  @override
  String get pageHeader => header;

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  late final MainBloc _mainBloc;

  @override
  void initState() {
    super.initState();
    _mainBloc = context.read();
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
            return RefreshIndicator(
              onRefresh: () async =>
                  _mainBloc.add(MainEvent.getData(filter: {})),
              color: AppColors.red,
              child: Scaffold(
                floatingActionButton:
                    authState.mapOrNull(authenticated: (value) {
                  if (value.user.userType.contains(UserType.ORG) ||
                      value.user.userType.contains(UserType.ADMIN)) {
                    return FloatingActionButton(
                      backgroundColor: AppColors.cyan,
                      child: const Icon(Icons.add),
                      onPressed: () =>
                          Navigator.pushNamed(context, CreateEvent.routeName),
                    );
                  }
                  return null;
                }),
                backgroundColor: AppColors.dark,
                body: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: mainState.mapOrNull(
                          loaded: (value) => ListView.builder(
                            itemCount: value.events.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: EventItem(event: value.events[index]),
                            ),
                          ),
                        ) ??
                        Center(
                            child: CircularProgressIndicator(
                          color: AppColors.red,
                        ))),
              ),
            );
          },
        );
      },
    );
  }
}
