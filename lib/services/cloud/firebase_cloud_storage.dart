import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/cloud_storage_exceptions.dart';

import 'cloud_storage_constants.dart';

class FirebaseCloudStorage{
  
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async{
    try{
      return await notes.where(
        ownerUserIdFieldName,
        isEqualTo: ownerUserId
      ).get().then(
        (value) => value.docs.map(
          (doc){  // gets data from snapshot and returns a doc
            return CloudNote(
              documentId: doc.id,
              ownerUserId: doc.data()[ownerUserIdFieldName] as String,
              text: doc.data()[textFieldName] as String,
            );
          }
        )
      );
    } catch(e){
      throw CouldNotGetallNotesException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    return notes.snapshots().map((event) => event.docs
      .map((doc) => CloudNote.fromSnapshot(doc))
      .where((note) => note.ownerUserId == ownerUserId));
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async{
    try{
      await notes.doc(documentId).update({textFieldName: text});
    } catch(e){
      throw CouldNotUpdateNoteException();
    }
  }
  
  Future<void> deleteNote({required String documentId}) async{
    try{
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }
  
  // send this to the cloud
  void createNewNote({required String ownerUserId}) async{
    notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
  }
  
  
  static final FirebaseCloudStorage _shared = 
      FirebaseCloudStorage._sharedInstance(); // FOLLOWING THREE LINES ARE TO MAKE FIREBASECLOUDSERVICE A SINGLETON !!!
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}