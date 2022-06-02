import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';

import 'firebase_options.dart';


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
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
      },
    ),
  );
}

class Homepage extends StatelessWidget {
  const Homepage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) { // Buld context is packaged info to pass info from one widget to another

    return FutureBuilder(  // run future value then build widget
        future: Firebase.initializeApp( // Initialize firebase here so we can use later
                  options: DefaultFirebaseOptions.currentPlatform,
                ),
        builder:(context, snapshot) { // snapshot is a state returns the result of our future
          switch (snapshot.connectionState){ // What do we do while connecting
            case ConnectionState.done: // If finished user will see this
              final user = FirebaseAuth.instance.currentUser;
              if (user != null){
                if (user.emailVerified){
                  print('Email is verified');
                }
                else{
                  return const VerifyEmailView();
                }
              }
              else {
                return const LoginView();
              }
              return const Text('Done');
                    //final user = FirebaseAuth.instance.currentUser; // ?? -> if user.emailVerified exists take that else false
                    //final emailVerified = user?.emailVerified ?? false;
                    //if(emailVerified == true){
                    //  print('You are a verified user');
                    //}
                    //else{
                    //  print('Verify Your email');
                    //  return const VerifyEmailView(); // Return verify email view if email not verified
                    // }
                    //return const Text('Done');
              return const LoginView();
          default:  // else user will see this text
            return const CircularProgressIndicator(); // Loading indicator
          }
          
        },
      );
  }
}



