import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/generics/get_arguments.dart';
import '../../services/auth/auth_service.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({ Key? key }) : super(key: key);

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {

  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  @override 
  void initState(){
    _notesService = NotesService();
    _textController  = TextEditingController();
    super.initState();
  }

  

  Future<DatabaseNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<DatabaseNote>();
    if (widgetNote!= null){
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }
    // Have we created this note before?
    final existingNote = _note;
    if (existingNote != null){
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!; // We expect a user exists if we are in this view else crash
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    final newNote = await _notesService.createNote(owner: owner);
    _note = newNote;
    log('returning new note');
    return newNote;
  }

  void _deleteNoteIfTextisEmpty(){
    final note = _note;
    if (_textController.text.isEmpty && note != null){
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async{
    final note = _note;
    final text = _textController.text;
    if(note != null && text.isNotEmpty){
      await _notesService.updateNote(
        note: note,
        text: text,
      );
    }
  }

  void _textControllerListener() async{   // Takes current note if it exists it will update textEditing controllers data into database
    final note = _note;
    if (note == null){
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(
      note: note,
      text: text,
    );
  }

  void _setupTextControllerListener(){
    _textController.removeListener(_textControllerListener);  // remove previous listener
    _textController.addListener(_textControllerListener); // adds it back
  }

  @override
  void dispose() {
    _deleteNoteIfTextisEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Note'),),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.done:
              _setupTextControllerListener();
              return TextField(
                controller: _textController,  // Link to our text controller
                keyboardType: TextInputType.multiline,
                maxLines: null,               // set to null for text lines to expand as you type !!!
                decoration: const InputDecoration(
                  hintText: 'My new note...'
                )
              );
            default:
              return const CircularProgressIndicator();
          }
        }
      ),
    );
  }
}