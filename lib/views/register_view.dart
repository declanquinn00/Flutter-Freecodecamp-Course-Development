import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'dart:developer' as devtools show log;
import '../firebase_options.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController
      _email; //Value of email will be generated later
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
        if(state is AuthStateRegistering){
          if (state.exception is WeakPasswordAuthException){
            await showErrorDialog(context, 'weak password');
          } else if (state.exception is EmailAlreadyInUseAuthException){
            await showErrorDialog(context, 'Email is already in use');
          } else if(state.exception is InvalidEmailAuthException){
            await showErrorDialog(context, 'Invalid email');
          } else if(state.exception is GenericAuthException){
            await showErrorDialog(context, 'Failed to register');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Column(
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
                final email = _email.text; // gets the text from _email controller
                final password = _password.text;
                context.read<AuthBloc>().add(AuthEventRegister(
                  email, 
                  password,
                  ),
                );
              },
              child: const Text('Register'),
            ),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                    const AuthEventLogOut(),
                  );
                },
                child: const Text('Go to Login'))
          ],
        ),
      ),
    );
  }
}
