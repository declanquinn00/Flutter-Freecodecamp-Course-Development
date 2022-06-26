class CloudStorageException implements Exception{
  const CloudStorageException();
}

class CouldNotCreateNoteException extends CloudStorageException{}

class CouldNotGetallNotesException extends CloudStorageException{}

class CouldNotUpdateNoteException extends CloudStorageException{}

class CouldNotDeleteNoteException extends CloudStorageException{}