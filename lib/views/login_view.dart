import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import '../firebase_options.dart';
import 'dart:developer' as devtools show log;

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
                FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: (email), password: password);
                devtools.log(userCredential.toString()); // prints a User Credential that is not used for anything else
                Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false,); // Push notes screen and remove everything else
              } on FirebaseAuthException catch(e){ // If authentication exception
                devtools.log(e.code.toString());
                if (e.code == 'user-not-found'){
                  devtools.log('User not found');
                }
                else if (e.code == 'wrong-password'){
                  devtools.log('Wrong Password');
                  devtools.log(e.code.toString());
                }
              }
              catch (e){ // If any other exception
                devtools.log('An error has occured');
                devtools.log(e.runtimeType.toString());
                devtools.log(e.toString());
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