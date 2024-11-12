import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:coursework1_mad/model/note_model.dart';
import 'package:coursework1_mad/controller/note_controller.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key, this.noteId, required this.userId});
  final int? noteId;
  final int userId;

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  final formKey = GlobalKey<FormState>();

  noteDatabaseController noteDatabase = noteDatabaseController.instance;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  late NoteModel note;
  bool isLoading = false;
  bool isNewNote = false;

  @override
  void initState() {
    refreshNotes();
    super.initState();
  }

  Future<void> refreshNotes() async {
    if (widget.noteId == null) {
      setState(() {
        isNewNote = true;
      });
      return;
    }
    note = await noteDatabase.getNote(widget.userId, widget.noteId!);
      setState(() {
        titleController.text = note.title ?? '';
        descriptionController.text = note.description ?? '';
        isLoading = false;
      });

  }

  addNote(NoteModel model) {
    noteDatabase.addNote(model).then((respond) async {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Note successfully added."),
      ));
      Navigator.pop(context, {'reload': true});
    }).catchError((error) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Note failed to save."),
      ));
    });
  }

  updateNote(NoteModel model) {
    noteDatabase.updateNote(model).then((respond) async {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Note successfully updated."),
      ));
      Navigator.pop(context, {'reload': true});
    }).catchError((error) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Note failed to update."),
      ));
    });
  }

  createNote() async {
    setState(() {
      isLoading = true;
    });

    if (formKey.currentState != null && formKey.currentState!.validate()) {
      formKey.currentState?.save();

      NoteModel model = NoteModel(
        userId: widget.userId,
        title: titleController.text,
        description: descriptionController.text,
      );
      if (isNewNote) {
        addNote(model);
      } else {
        model.id = note.id;
        updateNote(model);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a title.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xFFCFD8DC),
      appBar: AppBar(
        backgroundColor:const Color(0xFF78909C),
        title: Text(isNewNote ? 'Add a note' : 'Edit note'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Title"),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Enter the title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
                validator: validateTitle,
              ),
              const SizedBox(height: 20),
              const Text("Description"),
              Expanded(
                child: TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: "Enter the description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:const Color(0xFFECEFF1),
                  ),
                  onPressed: createNote,
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



