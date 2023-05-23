import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutofillGroup(
              child: Form(
                  child: Column(
                children: [
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [
                        AutofillHints.email,
                        AutofillHints.username,
                      ],
                      controller: _firstnameController,
                      style: AppStyles.textStyle,
                      decoration: AppStyles.inputFieldStyle
                          .copyWith(labelText: 'Firstname')),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [
                        AutofillHints.email,
                        AutofillHints.username,
                      ],
                      controller: _nicknameController,
                      style: AppStyles.textStyle,
                      decoration: AppStyles.inputFieldStyle
                          .copyWith(labelText: 'Nickname')),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [
                        AutofillHints.email,
                        AutofillHints.username,
                      ],
                      controller: _lastnameController,
                      style: AppStyles.textStyle,
                      decoration: AppStyles.inputFieldStyle
                          .copyWith(labelText: 'Lastname')),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [
                        AutofillHints.email,
                        AutofillHints.username,
                      ],
                      controller: _emailController,
                      style: AppStyles.textStyle,
                      decoration: AppStyles.inputFieldStyle
                          .copyWith(labelText: 'Email')),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      obscureText: true,
                      cursorColor: Colors.white,
                      controller: _passwordController,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      style: AppStyles.textStyle,
                      decoration: AppStyles.inputFieldStyle
                          .copyWith(labelText: 'Password')),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      obscureText: true,
                      cursorColor: Colors.white,
                      controller: _repeatPasswordController,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      style: AppStyles.textStyle,
                      decoration: AppStyles.inputFieldStyle
                          .copyWith(labelText: 'Repeat password')),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      onPressed: () => _authBloc.add(AuthEvent.register(
                          email: _emailController.text,
                          firstname: _firstnameController.text,
                          nickname: _nicknameController.text,
                          lasname: _lastnameController.text,
                          password: _passwordController.text,
                          repeatPassword: _repeatPasswordController.text)),
                      child: Text('Sign In',
                          style: AppStyles.textStyle.copyWith(
                              fontSize: 18,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey[900])),
                      onPressed: () => Navigator.pop(context),
                      child: Text('Back to login',
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
