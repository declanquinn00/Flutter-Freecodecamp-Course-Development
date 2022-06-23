import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log; 
import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../services/crud/notes_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({ Key? key }) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {

  String get userEmail => AuthService.firebase().currentUser!.email!;
  late final NotesService _notesService;

  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
        IconButton( // Adds a plus Button to go to new note view
          onPressed: (){
            Navigator.of(context).pushNamed(newNoteRoute); // Allows us to go back easily to notes view
          }, 
          icon: const Icon(Icons.add)
        ),
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
      body: FutureBuilder(    // returns a streambuilder that returns a list of notes
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot){
                  switch (snapshot.connectionState){
                    case ConnectionState.waiting:
                      return const Text('waiting for all notes...');
                    default:
                      return const CircularProgressIndicator();

                  }
                }
              );
            default:
              return const CircularProgressIndicator();
          }
        }
      )
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