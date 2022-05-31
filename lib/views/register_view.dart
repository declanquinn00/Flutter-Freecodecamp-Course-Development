import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({ Key? key }) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
        ),
      body: FutureBuilder(  // run future value then build widget
        future: Firebase.initializeApp(
                    options: DefaultFirebaseOptions.currentPlatform,
                ),
        builder:(context, snapshot) { // snapshot is a state returns the result of our future
          switch (snapshot.connectionState){ // What do we do while connecting
            case ConnectionState.done: // If finished user will see this
              return Column(
                children: [
                  TextField(
                    controller: _email, // Linked to our TextEditingController _email
                    keyboardType: TextInputType.emailAddress, // Necessary fields for email!!!
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(  // Decoration allows a hintText that dissapears when user starts typing
                      hintText: 'Enter your Email here',
                    )
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,  // Necessary fields for password text Fields!!!
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: 'Enter your password here',
                    )
                  ),
                  TextButton(
                    onPressed: () async{
                      
                      final email = _email.text; // gets the text from _email controller
                      final password = _password.text;
                      try{
                        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: (email), password: password);
                        print(userCredential);
                      } on FirebaseAuthException catch(e){
                        if (e.code == 'weak-password'){
                          print('Weak password');
                        }
                        else if (e.code == 'email-already-in-use'){
                          print('Email is already in use');
                        }
                        else if (e.code == 'invalid-email'){
                          print('Invalid email entered');
                        }
                        else{
                          print(e);
                        }
                      }

                    },
                    child: const Text('Register'),
                  ),
                ],
              );
          default:  // else user will see this text
            return const Text('Loading...');
          }
          
        },
      ),
    );
  }
}

