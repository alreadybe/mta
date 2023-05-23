import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mta_app/core/theme/styles.dart';
import 'package:mta_app/features/auth/bloc/auth_bloc.dart';
import 'package:mta_app/features/auth/bloc/auth_event.dart';
import 'package:mta_app/features/auth/bloc/auth_state.dart';
import 'package:mta_app/features/auth/view/signin.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final AuthBloc _authBloc;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _authBloc = context.read();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
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
                  ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      onPressed: () => _authBloc.add(AuthEvent.login(
                          email: _emailController.text,
                          password: _passwordController.text)),
                      child: Text('Login',
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
                      onPressed: () =>
                          Navigator.pushNamed(context, SignInPage.routeName),
                      child: Text('Sign In',
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
