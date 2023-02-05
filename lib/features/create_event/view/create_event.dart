import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mta_app/core/theme/colors.dart';
import 'package:mta_app/core/theme/styles.dart';
import 'package:mta_app/features/create_event/bloc/create_event_bloc.dart';
import 'package:mta_app/models/event_model.dart';
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
  DateTime? _eventDate;

  late final CreateEventBloc _createEventBloc;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _eventNameController = TextEditingController();
    _tourCountController = TextEditingController();
    _eloController = TextEditingController();
    _ptsController = TextEditingController();
    _descriptionController = TextEditingController();

    _eventType = EventType.SOLO;

    _createEventBloc = context.read();
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
      state.mapOrNull(
          created: (value) {
            Navigator.pop(context);
            EasyLoading.showSuccess('Event created');
          },
          error: (value) =>
              EasyLoading.showError(value.message ?? 'Unknow error'));
    }, builder: (context, state) {
      return DecoratedBox(
        decoration: BoxDecoration(color: Colors.grey[900]),
        child: state == CreateEventState.loading()
            ? CircularProgressIndicator(
                color: Colors.red[400],
                backgroundColor: Colors.grey[900],
              )
            : Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: _saveEvent,
                  backgroundColor: AppColors.accentViolet,
                  child: const Icon(Icons.check),
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 80,
                                child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Заполните поля';
                                      }
                                      return null;
                                    },
                                    controller: _eventNameController,
                                    style: AppStyles.textStyle,
                                    decoration: AppStyles.inputFieldStyle
                                        .copyWith(labelText: 'Название')),
                              ),
                              IconButton(
                                onPressed: () async {
                                  final newDate = await showDatePicker(
                                      builder: (context, child) => Theme(
                                            data: Theme.of(context).copyWith(
                                                colorScheme: ColorScheme.light(
                                                    primary: AppColors
                                                        .accentViolet)),
                                            child: child!,
                                          ),
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now()
                                          .subtract(const Duration(days: 30)),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 90)));
                                  setState(() {
                                    _eventDate = newDate;
                                  });
                                },
                                icon: const Icon(Icons.calendar_month),
                                iconSize: 32,
                                color: _eventDate == null
                                    ? Colors.red
                                    : Colors.green,
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
                                      width: MediaQuery.of(context).size.width /
                                              3 -
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
                                      width: MediaQuery.of(context).size.width /
                                              3 -
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
                                      width: MediaQuery.of(context).size.width /
                                              3 +
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
                                child: TextFormField(
                                    controller: _eloController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white, fontSize: 22),
                                    decoration:
                                        AppStyles.inputFieldStyle.copyWith(
                                      labelText: 'Elo рестрикт',
                                    )),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 4 - 30,
                                child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '';
                                      }
                                      return null;
                                    },
                                    controller: _tourCountController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white, fontSize: 22),
                                    decoration:
                                        AppStyles.inputFieldStyle.copyWith(
                                      labelText: 'Туров',
                                    )),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '';
                                      }
                                      return null;
                                    },
                                    controller: _ptsController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white, fontSize: 22),
                                    decoration:
                                        AppStyles.inputFieldStyle.copyWith(
                                      labelText: 'pts формат',
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          DecoratedBox(
                            decoration: AppStyles.backgroundBox,
                            child: TextFormField(
                                controller: _descriptionController,
                                maxLines: 20,
                                style:
                                    GoogleFonts.montserrat(color: Colors.white),
                                decoration: AppStyles.inputFieldStyle.copyWith(
                                  labelText: 'Описание',
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
              ),
      );
    });
  }

  Future<void> _saveEvent() async {
    if (_formKey.currentState!.validate() && _eventDate != null) {
      final event = EventModel(
        id: UniqueKey().toString(),
        date: _eventDate!,
        name: _eventNameController.value.text,
        type: _eventType,
        tours: int.parse(_tourCountController.value.text),
        pts: int.parse(_ptsController.value.text),
        elo: _eloController.value.text.isNotEmpty
            ? int.parse(_eloController.value.text)
            : null,
      );
      _createEventBloc.add(CreateEventEvent.createEvent(event: event));
    }
  }
}
