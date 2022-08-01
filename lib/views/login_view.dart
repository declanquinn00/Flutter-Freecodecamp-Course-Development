import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'dart:developer' as devtools show log;

import '../utilities/dialogs/error_dialog.dart';
import '../utilities/dialogs/loading_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email; //Value of email will be generated later
  late final TextEditingController _password;


  @override
  void initState() {
    //Initialise variables
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override //Dispose of variables when finished Very important!!
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
            if (state.exception is UserNotFoundAuthException) {
              await showErrorDialog(context, 'Cannot find a user with the entered credentials');
            } else if (state.exception is WrongPasswordAuthException) {
              await showErrorDialog(context, 'Wrong credentials');
            } else if (state.exception is GenericAuthException) {
              await showErrorDialog(context, 'Authentication error');
            }
          }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                    controller:
                        _email, // Linked to our TextEditingController _email
                    keyboardType:
                        TextInputType.emailAddress, // Necessary fields for email!!!
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      // Decoration allows a hintText that dissapears when user starts typing
                      hintText: 'Enter your Email here',
                    )),
                TextField(
                    controller: _password,
                    obscureText:
                        true, // Necessary fields for password text Fields!!!
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'Enter your password here',
                    )),
                TextButton(
                  onPressed: () async {
                    final email =
                        _email.text; // gets the text from _email controller
                    final password = _password.text;
                    context.read<AuthBloc>().add(
                          AuthEventLogIn(
                            email,
                            password,
                          ),
                        );
                  },
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      const AuthEventShouldRegister(),
                      );
                  },
                  child: const Text('Register Here'),
                ),
                TextButton(
                  onPressed: () async {
                    final email =
                        _email.text; // gets the text from _email controller
                    final password = _password.text;
                    context.read<AuthBloc>().add(
                          const AuthEventForgotPassword(),
                        );
                  },
                  child: const Text('Forgot password?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
