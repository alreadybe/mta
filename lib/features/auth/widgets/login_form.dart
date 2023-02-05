import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mta_app/core/theme/styles.dart';
import 'package:mta_app/features/auth/bloc/auth_bloc.dart';
import 'package:mta_app/features/auth/bloc/auth_event.dart';
import 'package:mta_app/features/auth/bloc/auth_state.dart';

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
            child: Form(
                child: Column(
              children: [
                TextFormField(
                    controller: _emailController,
                    style: AppStyles.textStyle,
                    decoration:
                        AppStyles.inputFieldStyle.copyWith(labelText: 'Login')),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _passwordController,
                    style: AppStyles.textStyle,
                    decoration: AppStyles.inputFieldStyle
                        .copyWith(labelText: 'Password')),
                ElevatedButton(
                    onPressed: () => _authBloc.add(AuthEvent.login(
                        email: _emailController.text,
                        password: _passwordController.text)),
                    child: const Text('Login'))
              ],
            )),
          ),
        );
      },
    );
  }
}
