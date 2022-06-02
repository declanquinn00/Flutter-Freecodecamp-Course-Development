import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';

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
                print(userCredential);
              } on FirebaseAuthException catch(e){ // If authentication exception
                print(e.code);
                if (e.code == 'user-not-found'){
                  print('User not found');
                }
                else if (e.code == 'wrong-password'){
                  print('Wrong Password');
                  print(e.code);
                }
              }
              catch (e){ // If any other exception
                print('An error has occured');
                print(e.runtimeType);
                print(e);
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () { 
            Navigator.of(context).pushNamedAndRemoveUntil('/register/', (route) => false); // Remove everything on screen and go to route with this string key
            },
            child: const Text('Register Here'),
          )
        ],
      ),
    );
  }

  
  
}