import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/login_view.dart';

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
    ),
  );
}

class Homepage extends StatelessWidget {
  const Homepage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        ),
      body: FutureBuilder(  // run future value then build widget
        future: Firebase.initializeApp(
                    options: DefaultFirebaseOptions.currentPlatform,
                ),
        builder:(context, snapshot) { // snapshot is a state returns the result of our future
          switch (snapshot.connectionState){ // What do we do while connecting
            case ConnectionState.done: // If finished user will see this
              final user = FirebaseAuth.instance.currentUser; // ?? -> if user.emailVerified exists take that else false
              final emailVerified = user?.emailVerified ?? false;
              if(emailVerified == true){
                print('You are a verified user');
              }
              else{
                print('Verify Your email');
              }
              return const Text('Done');
          default:  // else user will see this text
            return const Text('Loading...');
          }
          
        },
      ),
    );
  }
}

