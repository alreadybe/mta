import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mta_app/const/assets/assets.gen.dart';
import 'package:mta_app/core/theme/colors.dart';
import 'package:mta_app/core/theme/styles.dart';
import 'package:mta_app/features/auth/bloc/auth_bloc.dart';
import 'package:mta_app/features/auth/bloc/auth_state.dart';
import 'package:mta_app/features/auth/widgets/login_form.dart';
import 'package:mta_app/features/main/view/main_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = 'login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      state.mapOrNull(
        error: (value) {
          EasyLoading.showError(value.message ?? 'Something went wrong');
        },
        authenticated: (value) =>
            Navigator.pushReplacementNamed(context, MainPage.routeName),
      );
    }, builder: (context, state) {
      return SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: AppColors.dark,
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
                      'MEME TOURNAMENT APP',
                      style: AppStyles.textStyle
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 30),
                    Image.asset(
                      Assets.splashImage.path,
                      height: 300,
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    state.mapOrNull(
                            unauthenticated: (value) => const LoginForm(),
                            loading: (value) => SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 20,
                                child: LinearProgressIndicator(
                                    backgroundColor: AppColors.dark,
                                    color: AppColors.red))) ??
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
