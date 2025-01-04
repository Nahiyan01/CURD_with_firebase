import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //get collection of notes
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');
  //Create a new note
  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  //Read a note
  Stream<QuerySnapshot> getNotesStream() {
    return notes.orderBy('timestamp', descending: true).snapshots();
  }

  //Update a note
  Future<void> updateNotes(String? noteId, String newNote) {
    return notes.doc(noteId).update({
      'note': newNote,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  //Delete a note
  Future<void> deleteNotes(String? noteId) {
    return notes.doc(noteId).delete();
  }
}
