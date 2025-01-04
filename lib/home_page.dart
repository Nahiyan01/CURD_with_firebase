import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curd_firebase/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController _noteController = TextEditingController();

  void openNoteBox({String? noteId}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  hintText: 'Enter your note',
                ),
              ),
              actions: [
                TextButton(
                    onPressed: Navigator.of(context).pop,
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () {
                      if (noteId == null) {
                        firestoreService.addNote(_noteController.text);
                      } else {
                        firestoreService.updateNotes(
                            noteId, _noteController.text);
                      }
                      _noteController.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text("Add")),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: Center(child: Text('Note App')),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          //if we have data then get all the docs

          if (snapshot.hasData) {
            //the whole collection of notes/docs
            final notes = snapshot.data!.docs;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, int index) {
                final note = notes[index];
                String noteId = note.id;
                //get node from each doc
                Map<String, dynamic> noteData =
                    note.data() as Map<String, dynamic>;
                String noteText = noteData['note'];
                return ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () => openNoteBox(noteId: noteId),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => firestoreService.deleteNotes(noteId),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        backgroundColor: Colors.grey[700],
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
