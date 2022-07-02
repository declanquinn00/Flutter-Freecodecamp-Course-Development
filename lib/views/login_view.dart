import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'dart:developer' as devtools show log;

import '../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({ Key? key }) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email; //Value of email will be generated later
  late final TextEditingController _password;
  
  @override
  void initState() { //Initialise variables
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }
  
  @override //Dispose of variables when finished Very important!!
  void dispose(){
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login')
        ),
      body: Column(
        children: [
          TextField(
            controller: _email, // Linked to our TextEditingController _email
            keyboardType: TextInputType.emailAddress, // Necessary fields for email!!!
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(  // Decoration allows a hintText that dissapears when user starts typing
              hintText: 'Enter your Email here',
            )
          ),
          TextField(
            controller: _password,
            obscureText: true,  // Necessary fields for password text Fields!!!
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password here',
            )
          ),
          TextButton(
            onPressed: () async{
              
              final email = _email.text; // gets the text from _email controller
              final password = _password.text;
              try{
                context.read<AuthBloc>().add(
                  AuthEventLogIn(
                    email, 
                    password,
                  )
                );
              } on UserNotFoundAuthException{
                devtools.log('User not found');
                await showErrorDialog(context, 'User not found',);
              } on WrongPasswordAuthException{
                devtools.log('Wrong Password');
                await showErrorDialog(context, 'Wrong Password',);
              } on GenericAuthException{
                await showErrorDialog(context, 'Authenitcation error');
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () { 
            Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false); // Remove everything on screen and go to route with this string key
            },
            child: const Text('Register Here'),
          )
        ],
      ),
    );
  } 
}

