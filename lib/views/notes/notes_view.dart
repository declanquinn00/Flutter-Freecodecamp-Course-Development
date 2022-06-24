import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/dialogs/logout_dialog.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';
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
                    case ConnectionState.active: // Fallthrough from waiting to active
                      if (snapshot.hasData){
                        final allNotes = snapshot.data as List<DatabaseNote>;
                        return NotesListView(
                          notes: allNotes, 
                          onDeleteNote: (note) async{
                            await _notesService.deleteNote(id: note.id);
                          },
                        );
                      }else{
                        return const CircularProgressIndicator();
                      }
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

