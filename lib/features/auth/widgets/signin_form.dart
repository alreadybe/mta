import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mta_app/core/theme/colors.dart';
import 'package:mta_app/core/theme/styles.dart';
import 'package:mta_app/features/auth/bloc/auth_bloc.dart';
import 'package:mta_app/features/auth/bloc/auth_event.dart';
import 'package:mta_app/features/auth/bloc/auth_state.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  late final AuthBloc _authBloc;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _firstnameController;
  late final TextEditingController _nicknameController;
  late final TextEditingController _lastnameController;
  late final TextEditingController _repeatPasswordController;

  int stage = 0;

  @override
  void initState() {
    _authBloc = context.read();
    _firstnameController = TextEditingController();
    _nicknameController = TextEditingController();
    _lastnameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _nicknameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firstStageFields = <Widget>[
      TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          cursorColor: Colors.white,
          autofillHints: const [
            AutofillHints.email,
            AutofillHints.username,
          ],
          controller: _emailController,
          style: AppStyles.textStyle,
          decoration: AppStyles.inputFieldStyle.copyWith(
              labelText: 'Email',
              icon: Icon(Icons.email, color: AppColors.lightDark))),
      const SizedBox(
        height: 30,
      ),
      TextFormField(
          obscureText: true,
          cursorColor: Colors.white,
          controller: _passwordController,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          style: AppStyles.textStyle,
          decoration: AppStyles.inputFieldStyle.copyWith(
              labelText: 'Password',
              icon: Icon(Icons.password_sharp, color: AppColors.lightDark))),
      const SizedBox(
        height: 30,
      ),
      TextFormField(
          obscureText: true,
          cursorColor: Colors.white,
          controller: _repeatPasswordController,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          style: AppStyles.textStyle,
          decoration: AppStyles.inputFieldStyle.copyWith(
              labelText: 'Repeat password',
              icon: Icon(Icons.password_rounded, color: AppColors.lightDark))),
    ];

    final secondStageField = <Widget>[
      TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.name],
          controller: _firstnameController,
          style: AppStyles.textStyle,
          decoration: AppStyles.inputFieldStyle.copyWith(
              labelText: 'Firstname',
              icon: Icon(Icons.list_outlined, color: AppColors.lightDark))),
      const SizedBox(
        height: 30,
      ),
      TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.name],
          controller: _nicknameController,
          style: AppStyles.textStyle,
          decoration: AppStyles.inputFieldStyle.copyWith(
              labelText: 'Nickname',
              icon: Icon(Icons.list_outlined, color: AppColors.lightDark))),
      const SizedBox(
        height: 30,
      ),
      TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.name],
          controller: _lastnameController,
          style: AppStyles.textStyle,
          decoration: AppStyles.inputFieldStyle.copyWith(
              labelText: 'Lastname',
              icon: Icon(Icons.list_outlined, color: AppColors.lightDark))),
    ];
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) => state.mapOrNull(
        loading: (value) => EasyLoading.show(),
      ),
      builder: (context, state) {
        return SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
            child: AutofillGroup(
              child: Form(
                  child: Column(
                children: [
                  ...stage == 0 ? firstStageFields : secondStageField,
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      onPressed: () => stage == 0
                          ? {
                              _authBloc.add(AuthEvent.checkEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  repeatPassword:
                                      _repeatPasswordController.text)),
                              setState(() {
                                stage = 1;
                              }),
                              FocusManager.instance.primaryFocus?.unfocus(),
                            }
                          : _authBloc.add(AuthEvent.register(
                              email: _emailController.text,
                              firstname: _firstnameController.text,
                              nickname: _nicknameController.text,
                              lasname: _lastnameController.text,
                              password: _passwordController.text,
                              repeatPassword: _repeatPasswordController.text)),
                      child: Text(stage == 0 ? 'Next' : 'Sign In',
                          style: AppStyles.textStyle.copyWith(
                              fontSize: 18,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey[900])),
                      onPressed: () => stage == 0
                          ? Navigator.pop(context)
                          : setState(() {
                              stage = 0;
                            }),
                      child: Text(stage == 0 ? 'Back to login' : 'Back',
                          style: AppStyles.textStyle.copyWith(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)))
                ],
              )),
            ),
          ),
        );
      },
    );
  }
}
