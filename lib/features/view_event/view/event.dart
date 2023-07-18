import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mta_app/core/theme/colors.dart';
import 'package:mta_app/core/theme/styles.dart';
import 'package:mta_app/features/auth/bloc/auth_bloc.dart';
import 'package:mta_app/features/auth/bloc/auth_state.dart';
import 'package:mta_app/features/edit_event/bloc/edit_event_bloc.dart';
import 'package:mta_app/features/edit_event/view/edit_event.dart';
import 'package:mta_app/features/edit_event/view/start_event.dart';
import 'package:mta_app/features/main/bloc/main_bloc.dart';
import 'package:mta_app/features/view_event/bloc/event_bloc.dart';
import 'package:mta_app/models/event_model.dart';
import 'package:mta_app/models/event_status.dart';
import 'package:mta_app/models/user_type_model.dart';
import 'package:url_launcher/url_launcher.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  static const routeName = 'event';

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late EventBloc _eventBloc;
  late MainBloc _mainBloc;
  late EditEventBloc _editEventBloc;

  @override
  void initState() {
    _eventBloc = context.read();
    _mainBloc = context.read();
    _editEventBloc = context.read();
    super.initState();
  }

  Future<void> _launchUrl(Uri url, EventModel event) async {
    try {
      if (!await launchUrl(url)) {
        _eventBloc.add(EventEvent.error(
            message: 'Broken link, contact to org', event: event));
      }
    } on Exception {
      _eventBloc.add(EventEvent.error(
          message: 'Broken link, contact to org', event: event));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditEventBloc, EditEventState>(
      builder: (context, editEventState) {
        return BlocBuilder<MainBloc, MainState>(
          builder: (context, mainState) {
            return BlocConsumer<EventBloc, EventState>(
              listener: (context, state) => state.mapOrNull(
                userApplied: (value) {
                  _mainBloc.add(MainEvent.getData(filter: {}));
                  return EasyLoading.showSuccess('Request send!');
                },
                error: (value) => EasyLoading.showError(
                    value.message ?? 'Something went wrong'),
              ),
              builder: (context, state) {
                return state.maybeMap(
                  loaded: (value) => BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authState) {
                      return Scaffold(
                        floatingActionButton:
                            authState.maybeMap(authenticated: (userValue) {
                          if (!userValue.user.userType
                                  .contains(UserType.WAITING_APPROVE) &&
                              value.event.appliedPlayers != null &&
                              value.event.appliedPlayers!
                                  .where((element) =>
                                      element.userId == userValue.user.id)
                                  .toList()
                                  .isEmpty) {
                            return FloatingActionButton(
                                backgroundColor: AppColors.cyan,
                                child: const Icon(
                                  Icons.library_add_check_rounded,
                                  size: 28,
                                ),
                                onPressed: () => _eventBloc.add(
                                    EventEvent.apply(
                                        user: userValue.user,
                                        event: value.event)));
                          } else {
                            return null;
                          }
                        }, orElse: () {
                          return null;
                        }),
                        backgroundColor: AppColors.dark,
                        appBar: AppBar(
                          backgroundColor: AppColors.lightDark,
                          title: Text(
                            value.event.name,
                            style: AppStyles.textStyle
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          actions: [
                            authState.maybeMap(authenticated: (userValue) {
                              if (userValue.user.id == value.event.orgUserId) {
                                return IconButton(
                                    onPressed: () {
                                      if (value.event.status ==
                                          EventStatus.FINISHED) {
                                        _editEventBloc.add(
                                            EditEventEvent.finishEvent(
                                                event: value.event));
                                      } else {
                                        _editEventBloc.add(
                                            EditEventEvent.loadEvent(
                                                event: value.event));
                                      }
                                      if (value.event.status ==
                                          EventStatus.INCOMING) {
                                        Navigator.pushNamed(
                                            context, StartEventPage.routeName);
                                      } else {
                                        Navigator.pushNamed(
                                            context, EditEventPage.routeName);
                                      }
                                    },
                                    icon: Icon(
                                      value.event.status == EventStatus.INCOMING
                                          ? Icons.start
                                          : value.event.status ==
                                                  EventStatus.INPROGRESS
                                              ? Icons.edit
                                              : Icons.view_agenda,
                                      color: AppColors.cyan,
                                    ));
                              } else {
                                return const SizedBox();
                              }
                            }, orElse: () {
                              return const SizedBox();
                            }),
                          ],
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        body: SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 30),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(children: [
                                      Text(
                                        'Event date:',
                                        style: AppStyles.textStyle,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '${value.event.date.hour}:${value.event.date.minute}',
                                        style: AppStyles.textStyle
                                            .copyWith(fontSize: 22),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${value.event.date.day}.${value.event.date.month}.${value.event.date.year}',
                                        style: AppStyles.textStyle
                                            .copyWith(fontSize: 18),
                                      ),
                                    ]),
                                    Column(
                                      children: [
                                        Text(
                                          'Applied players:',
                                          style: AppStyles.textStyle,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          (value.event.appliedPlayers?.length ??
                                                  0)
                                              .toString(),
                                          style: AppStyles.textStyle
                                              .copyWith(fontSize: 32),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                ElevatedButton(
                                    style: ButtonStyle(
                                        minimumSize: MaterialStateProperty.all(
                                            Size(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                40)),
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                AppColors.cyan)),
                                    onPressed: () {
                                      _launchUrl(
                                          Uri.parse(
                                              value.event.reglament ?? ''),
                                          value.event);
                                    },
                                    child: Text('Go to reglament',
                                        style: AppStyles.textStyle.copyWith(
                                            fontSize: 16,
                                            color: AppColors.dark,
                                            fontWeight: FontWeight.bold))),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      '${value.event.pts} pts',
                                      style: AppStyles.textStyle
                                          .copyWith(fontSize: 18),
                                    ),
                                    Text(
                                      '${value.event.elo ?? "No"} elo limit',
                                      style: AppStyles.textStyle
                                          .copyWith(fontSize: 18),
                                    ),
                                    Text(
                                      '${value.event.tours} tours',
                                      style: AppStyles.textStyle
                                          .copyWith(fontSize: 18),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.lightDark,
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    value.event.description ?? 'No details',
                                    style: AppStyles.textStyle
                                        .copyWith(fontSize: 17),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  orElse: () => ColoredBox(
                    color: AppColors.dark,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.red,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
