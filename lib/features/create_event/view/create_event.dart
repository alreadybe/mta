import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mta_app/core/theme/colors.dart';
import 'package:mta_app/core/theme/styles.dart';
import 'package:mta_app/features/create_event/bloc/create_event_bloc.dart';
import 'package:mta_app/features/create_event/bloc/create_event_event.dart';
import 'package:mta_app/features/create_event/bloc/create_event_state.dart';
import 'package:mta_app/models/event.dart';
import 'package:mta_app/models/event_type.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({Key? key}) : super(key: key);

  static const routeName = 'create_event';

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  late TextEditingController _eventNameController;
  late TextEditingController _tourCountController;
  late TextEditingController _eloController;
  late TextEditingController _ptsController;
  late TextEditingController _descriptionController;

  late EventType _eventType;
  late DateTime _eventDate;

  @override
  void initState() {
    _eventNameController = TextEditingController();
    _tourCountController = TextEditingController();
    _eloController = TextEditingController();
    _ptsController = TextEditingController();
    _descriptionController = TextEditingController();

    _eventType = EventType.SOLO;
    _eventDate = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _tourCountController.dispose();
    _eloController.dispose();
    _ptsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateEventBloc, CreateEventState>(
        listener: (context, state) {
      print('getted state');
      state.mapOrNull(
        error: (value) =>
            showAboutDialog(context: context, children: [Text(value.message!)]),
      );
    }, builder: (context, state) {
      return DecoratedBox(
        decoration: BoxDecoration(color: AppColors.dark),
        child: state == const CreateEventState.loading()
            ? const CircularProgressIndicator()
            : Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: _saveEvent,
                  backgroundColor: AppColors.accentViolet,
                  child: const Icon(Icons.create),
                ),
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text(
                    'Создать турнир',
                    style: AppStyles.textStyle,
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: SafeArea(
                    child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 80,
                              child: TextField(
                                  controller: _eventNameController,
                                  style: AppStyles.textStyle,
                                  decoration: AppStyles.inputFieldStyle
                                      .copyWith(hintText: 'Название')),
                            ),
                            IconButton(
                              onPressed: () async {
                                _eventDate = (await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now()
                                        .subtract(const Duration(days: 30)),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 90))))!;
                              },
                              icon: const Icon(Icons.calendar_month),
                              iconSize: 32,
                              color: Colors.white,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: AppStyles.backgroundBox,
                          child: Column(
                            children: [
                              Align(
                                child: Text(
                                  'Тип',
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3 -
                                            31,
                                    child: RadioListTile<EventType>(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 5),
                                      activeColor: AppColors.accentViolet,
                                      title: Text(
                                        'Соло',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white),
                                      ),
                                      value: EventType.SOLO,
                                      groupValue: _eventType,
                                      onChanged: (value) {
                                        setState(() {
                                          _eventType = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3 -
                                            38,
                                    child: RadioListTile<EventType>(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 5),
                                      activeColor: AppColors.accentViolet,
                                      title: Text(
                                        'Фан',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white),
                                      ),
                                      value: EventType.FUN,
                                      groupValue: _eventType,
                                      onChanged: (value) {
                                        setState(() {
                                          _eventType = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3 +
                                            10,
                                    child: RadioListTile<EventType>(
                                      activeColor: AppColors.accentViolet,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 5),
                                      title: Text(
                                        'Команды',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white),
                                      ),
                                      value: EventType.TEAM,
                                      groupValue: _eventType,
                                      onChanged: (value) {
                                        setState(() {
                                          _eventType = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: TextField(
                                  controller: _eloController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white, fontSize: 22),
                                  decoration:
                                      AppStyles.inputFieldStyle.copyWith(
                                    hintText: 'Elo рестрикт',
                                  )),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 4 - 30,
                              child: TextField(
                                  controller: _tourCountController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white, fontSize: 22),
                                  decoration:
                                      AppStyles.inputFieldStyle.copyWith(
                                    hintText: 'Туров',
                                  )),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: TextField(
                                  controller: _ptsController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white, fontSize: 22),
                                  decoration:
                                      AppStyles.inputFieldStyle.copyWith(
                                    hintText: 'pts формат',
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        DecoratedBox(
                          decoration: AppStyles.backgroundBox,
                          child: TextField(
                              controller: _descriptionController,
                              maxLines: 20,
                              style:
                                  GoogleFonts.montserrat(color: Colors.white),
                              decoration: AppStyles.inputFieldStyle.copyWith(
                                hintText: 'Описание',
                              )),
                        ),
                      ],
                    ),
                  ),
                )),
              ),
      );
    });
  }

  Future<void> _saveEvent() async {
    if (_eventNameController.text.isEmpty ||
        _tourCountController.text.isEmpty ||
        _ptsController.text.isEmpty) {
      CreateEventBloc()
          .add(const CreateEventEvent.error(message: 'Заполните все данные'));
      return;
    }
    final event = Event(
      id: UniqueKey().toString(),
      date: _eventDate,
      name: _eventNameController.text,
      type: _eventType,
      tours: int.parse(_tourCountController.text),
      pts: int.parse(_ptsController.text),
      elo: _eloController.text.isNotEmpty
          ? int.parse(_eloController.text)
          : null,
    );
    CreateEventBloc().add(CreateEventEvent.createEvent(event: event));
  }
}
