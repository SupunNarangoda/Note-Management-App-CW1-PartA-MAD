import 'package:flutter/material.dart';
import 'package:coursework1_mad/model/note_model.dart';
import 'package:coursework1_mad/controller/note_controller.dart';
import 'package:coursework1_mad/view/Note/note_detailed_view.dart';
import 'package:coursework1_mad/view/login/login_view.dart';
import 'package:coursework1_mad/view/Note/note_detail_popup.dart';

class Home extends StatefulWidget {
  final int userId;
  const Home({Key? key, required this.userId}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  noteDatabaseController noteDatabase = noteDatabaseController.instance;
  List<NoteModel> notes = [];


  @override
  void initState() {
    super.initState();
    refreshNotes(widget.userId);
  }

  void refreshNotes(int userId) async {
    final value = await noteDatabase.getAllNotes(userId);
    setState(() {
      notes = value;
    });
  }

  void logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  goToNoteDetailsView({int? id , required int userId}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteView(noteId: id,userId: userId)),
    );
    refreshNotes(userId);
  }

  deleteNoteDialog({required int id , required int userId}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Row(children: [
              Icon(
                Icons.delete,
                color: Color.fromARGB(255, 255, 81, 0),
              ),
              SizedBox(width: 8),
              Text('Delete Note'),
            ]),
            content: const Text('Are you sure you want to delete this note?'),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  await noteDatabase.deleteNote(id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Note successfully deleted."),
                    backgroundColor: Color.fromARGB(255, 235, 108, 108),
                  ));
                  refreshNotes(userId);
                },
                child: const Text('Yes'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('No'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xFFCFD8DC),
      appBar: AppBar(
        backgroundColor:const Color(0xFF78909C),
        automaticallyImplyLeading: false,
        title: const Text("MySimpleNote",
        style:  TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 27,
        ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: notes.isEmpty
          ? const Center(
        child: Text(
          "No records to display",
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return buildNoteCard(notes[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:const Color(0xFFECEFF1),
        onPressed: () => goToNoteDetailsView(userId: widget.userId), // Create a new note
        tooltip: 'Create Note',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Helper method to build a note card with popup on tap and delete on long press
  Widget buildNoteCard(NoteModel note) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0), // Adds spacing around each card
      child: SizedBox(
        height: 80, // Sets a custom height for the card to make it bigger
        child: Card(
          color: Colors.blueGrey[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Makes the card corners rounded
          ),
          elevation: 2, // Optional: add shadow to make the card stand out
          child: Padding(
            padding: const EdgeInsets.all(8.0), // Adds padding inside the card for spacing
            child: ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => NoteDetailPopup(note: note),
                );
              },
              onLongPress: () => deleteNoteDialog(id: note.id!, userId: widget.userId), // Show delete dialog on long press
              leading: const Image(
                image: AssetImage('assets/images/note.png'),
                width: 60, // Optional: adjust size of the image
                height: 60,
              ),
              title: Text(
                note.title ?? "",
                style: const TextStyle(
                    fontSize: 20,
                ), // Increase font size for title
              ),
              trailing: IconButton(
                onPressed: () => goToNoteDetailsView(id: note.id,userId: widget.userId), // Edit note
                icon: const Icon(Icons.edit_document),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


