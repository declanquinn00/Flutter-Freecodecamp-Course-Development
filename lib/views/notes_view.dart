import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log; 
import '../constants/routes.dart';
import '../enums/menu_action.dart';

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
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
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