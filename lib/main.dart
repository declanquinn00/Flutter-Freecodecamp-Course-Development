import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
//import 'dart:developer' as devtools show log; //Only show log options from dart:developer by typing devtools.XXX
//import 'firebase_options.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized(); // ensure firebase gets initialized
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Homepage(),
      routes: {   // Named paths to different views with strings as keys
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),
  );
}

class Homepage extends StatelessWidget {
  const Homepage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) { // Buld context is packaged info to pass info from one widget to another
    return FutureBuilder(  // run future value then build widget
        future: AuthService.firebase().initialize(),
        builder:(context, snapshot) { // snapshot is a state returns the result of our future
          switch (snapshot.connectionState){ // What do we do while connecting
            case ConnectionState.done: // If finished user will see this
              final user = AuthService.firebase().currentUser;
              if (user != null){
                if (user.isEmailVerified){
                  return const NotesView(); // Main UI screen
                }
                else{
                  return const VerifyEmailView();
                }
              }
              else {
                return const LoginView();
              }
          default:  // else user will see this text
            return const CircularProgressIndicator(); // Loading indicator
          }
        },
      );
  }
}



