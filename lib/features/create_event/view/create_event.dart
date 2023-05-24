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
  late TextEditingController _reglamentController;
  late TextEditingController _memberNumber;

  late EventType _eventType;
  late DateTime? _eventDate;
  late Duration? _eventTime;

  bool settedTime = false;
  bool settedDate = false;

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
    _reglamentController = TextEditingController();
    _memberNumber = TextEditingController();

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
    _reglamentController.dispose();
    _memberNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateEventBloc, CreateEventState>(
        listener: (context, state) {
      state.mapOrNull(
          loading: (value) => EasyLoading.show(),
          created: (value) {
            Navigator.pop(context);
            EasyLoading.showSuccess('Event created');
          },
          error: (value) =>
              EasyLoading.showError(value.message ?? 'Unknow error'));
    }, builder: (context, state) {
      return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: _saveEvent,
            backgroundColor: AppColors.cyan,
            isExtended: true,
            child: const Icon(Icons.save),
          ),
          backgroundColor: AppColors.dark,
          appBar: AppBar(
            backgroundColor: AppColors.lightDark,
            title: Text(
              'Create Event',
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
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '';
                              }
                              return null;
                            },
                            controller: _eventNameController,
                            style: AppStyles.textStyle,
                            decoration: AppStyles.inputFieldStyle.copyWith(
                                labelText: 'Name',
                                icon: Icon(Icons.label_outline_rounded,
                                    color: AppColors.lightDark)))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Choose day: ',
                          style: AppStyles.textStyle,
                        ),
                        IconButton(
                          onPressed: () async {
                            final newDate = await showDatePicker(
                                builder: (context, child) => Theme(
                                      data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                              primary: AppColors.cyan)),
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
                              settedDate = true;
                            });
                          },
                          icon: const Icon(Icons.calendar_month),
                          iconSize: 32,
                          color: settedDate ? Colors.green : Colors.red,
                        ),
                        Text(
                          'Choose time: ',
                          style: AppStyles.textStyle,
                        ),
                        IconButton(
                          onPressed: () async {
                            final newTime = await showTimePicker(
                              builder: (context, child) => Theme(
                                data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                        primary: AppColors.cyan)),
                                child: child!,
                              ),
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            setState(() {
                              _eventTime = Duration(
                                  hours: newTime?.hour ?? 0,
                                  minutes: newTime?.minute ?? 0);
                              settedTime = true;
                            });
                          },
                          icon: const Icon(Icons.timelapse_outlined),
                          iconSize: 32,
                          color: settedTime ? Colors.green : Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, bottom: 10),
                                child: Text('Type', style: AppStyles.textStyle),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: RadioListTile<EventType>(
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  activeColor: AppColors.cyan,
                                  title: Text(
                                    'Solo',
                                    style: GoogleFonts.montserrat(
                                        color: AppColors.white),
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
                                width: MediaQuery.of(context).size.width / 3,
                                child: RadioListTile<EventType>(
                                  activeColor: AppColors.cyan,
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  title: Text(
                                    'Team',
                                    style: GoogleFonts.montserrat(
                                        color: AppColors.white),
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '';
                                      }
                                      return null;
                                    },
                                    cursorColor: AppColors.cyan,
                                    controller: _memberNumber,
                                    keyboardType: TextInputType.number,
                                    style: GoogleFonts.montserrat(
                                        color: Colors.cyan, fontSize: 22),
                                    decoration:
                                        AppStyles.inputFieldStyle.copyWith(
                                      labelText: 'Member number',
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: TextFormField(
                                    cursorColor: AppColors.cyan,
                                    controller: _eloController,
                                    keyboardType: TextInputType.number,
                                    style: GoogleFonts.montserrat(
                                        color: Colors.cyan, fontSize: 22),
                                    decoration:
                                        AppStyles.inputFieldStyle.copyWith(
                                      labelText: 'ELO (if needed)',
                                    )),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: TextFormField(
                                    cursorColor: AppColors.cyan,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '';
                                      }
                                      return null;
                                    },
                                    controller: _tourCountController,
                                    keyboardType: TextInputType.number,
                                    style: GoogleFonts.montserrat(
                                        color: Colors.cyan, fontSize: 22),
                                    decoration:
                                        AppStyles.inputFieldStyle.copyWith(
                                      labelText: 'Tour number',
                                    )),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: TextFormField(
                                    cursorColor: AppColors.cyan,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '';
                                      }
                                      return null;
                                    },
                                    controller: _ptsController,
                                    keyboardType: TextInputType.number,
                                    style: GoogleFonts.montserrat(
                                        color: Colors.cyan, fontSize: 22),
                                    decoration:
                                        AppStyles.inputFieldStyle.copyWith(
                                      labelText: 'PTS format',
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '';
                          }
                          return null;
                        },
                        controller: _reglamentController,
                        cursorColor: AppColors.cyan,
                        keyboardType: TextInputType.url,
                        style: GoogleFonts.montserrat(
                            color: Colors.cyan, fontSize: 18),
                        decoration: AppStyles.inputFieldStyle.copyWith(
                            labelText: 'Regulations link',
                            icon: Icon(
                              Icons.link,
                              color: AppColors.lightDark,
                            ))),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Short description:',
                      style: AppStyles.textStyle,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DecoratedBox(
                      decoration: AppStyles.backgroundBox,
                      child: TextFormField(
                          cursorColor: AppColors.cyan,
                          controller: _descriptionController,
                          maxLines: 15,
                          style: GoogleFonts.montserrat(color: Colors.cyan),
                          decoration: AppStyles.inputFieldStyle.copyWith(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.all(10),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          )));
    });
  }

  Future<void> _saveEvent() async {
    if (_formKey.currentState!.validate() &&
        settedDate &&
        settedTime &&
        int.tryParse(_memberNumber.text) != null) {
      final event = EventModel(
        id: UniqueKey().toString(),
        date: _eventDate!.add(_eventTime!),
        name: _eventNameController.value.text,
        description: _descriptionController.text,
        reglament: _reglamentController.text,
        type: _eventType,
        memberNumber: int.tryParse(_memberNumber.text)!,
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
