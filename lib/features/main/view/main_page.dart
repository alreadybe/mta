import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mta_app/features/create_event/view/create_event.dart';
import 'package:mta_app/features/edit_event/view/edit_event.dart';
import 'package:mta_app/features/main/bloc/main_bloc.dart';

class MainPage extends StatefulWidget {
  static const routeName = 'main';

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
      builder: (context, state) {
        state.mapOrNull(
          initial: (value) => _mainBloc.add(MainEvent.getData(filter: {})),
        );
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Pairing app'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      child: const Text('Create event'),
                      onPressed: () =>
                          Navigator.pushNamed(context, CreateEvent.routeName)),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      child: const Text('Edit event'),
                      onPressed: () =>
                          _mainBloc.add(MainEvent.getData(filter: {}))),
                  SizedBox(
                      height: 200,
                      child: state.mapOrNull(
                            loaded: (value) => ListView.builder(
                              itemCount: value.events.length,
                              itemBuilder: (context, index) =>
                                  Text(value.events[index].name),
                            ),
                          ) ??
                          const CircularProgressIndicator())
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
