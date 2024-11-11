import 'package:flutter/material.dart';
import 'package:coursework1_mad/model/note_model.dart';

class NoteDetailPopup extends StatelessWidget {
  final NoteModel note;

  const NoteDetailPopup({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFECEFF1),
      title: const Text(
        "Note Details",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Title:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              note.title ?? "Untitled",
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const Divider(height: 20, thickness: 1),
            const Text(
              "Description:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              note.description ?? "No description available.",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
      ],
    );
  }
}
