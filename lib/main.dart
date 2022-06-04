import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
import 'dart:developer' as devtools show log; //Only show log options from dart:developer by typing devtools.XXX
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

enum MenuAction{ logout } // what happens in menu

class NotesView extends StatefulWidget {
  const NotesView({ Key? key }) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
         PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value){
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  devtools.log(shouldLogout.toString());
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
                  }
                  break;
              }
              devtools.log(value.toString()); // log always takes a string
            },
            itemBuilder: (context){
              return [
              const PopupMenuItem<MenuAction>(
              value: MenuAction.logout, 
              child: Text('Logout'),
              )
            ];
          },
         ) 
        ],
      ),
      body: const Text('Hello World'),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context){    // Shows dialog when logout is pressed return true or false
  return showDialog<bool>(
    context: context, 
    builder: (context){
      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [  // 2 buttons either logs out our cancels
          TextButton(
            onPressed: (){Navigator.of(context).pop(false);}, child: const Text('Cancel')),
          TextButton(
            onPressed: (){Navigator.of(context).pop(true);}, child: const Text('Logout')),
        ]
      );
    },
  ).then((value) => value ?? false);  // .then means we return our assertation here
}
