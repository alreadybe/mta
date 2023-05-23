import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mta_app/core/theme/styles.dart';
import 'package:mta_app/features/auth/bloc/auth_bloc.dart';
import 'package:mta_app/features/auth/bloc/auth_event.dart';
import 'package:mta_app/features/auth/bloc/auth_state.dart';
import 'package:mta_app/features/auth/widgets/signin_form.dart';
import 'package:mta_app/features/main/view/main_page.dart';

class SignInPage extends StatefulWidget {
  static const routeName = 'signin';

  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final AuthBloc _authBloc;

  @override
  void initState() {
    _authBloc = context.read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      state.mapOrNull(
        error: (value) {
          EasyLoading.showError(value.message ?? 'Something went wrong');
          _authBloc.add(const AuthEvent.logout());
        },
        authenticated: (value) =>
            Navigator.pushReplacementNamed(context, MainPage.routeName),
      );
    }, builder: (context, state) {
      return SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: Colors.grey[900],
            body: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  top: MediaQuery.of(context).size.height / 2 - 380),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'HELLO MOTHERFUCKER',
                      style: AppStyles.textStyle
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    state.mapOrNull(
                            unauthenticated: (value) => const SignInForm(),
                            loading: (value) => SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 20,
                                child: LinearProgressIndicator(
                                    backgroundColor: Colors.grey[900],
                                    color: Colors.red[400]))) ??
                        const SizedBox(),
                  ],
                ),
              ),
            )),
          ),
        ),
      );
    });
  }
}
