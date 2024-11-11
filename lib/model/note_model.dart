class NoteModel {
  // Define class properties
  int? id; // User ID
  String? title; // User name
  String? description; // User email
  int? userId;

  // Constructor with optional 'id' parameter
  // NoteModel(this.title, this.description, {this.id,this.userId});
  NoteModel({this.id, this.title, this.description,this.userId});

  // Convert a Note into a Map. The keys must correspond to the names of the
  // columns in the database.
  NoteModel.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    userId = map['userId'];
  }

// Method to convert a 'NoteModel' to a map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'userId': userId,
    };
  }
}