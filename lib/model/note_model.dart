class NoteModel {
  int? id;
  String? title;
  String? description;
  int? userId;


  NoteModel({this.id, this.title, this.description,this.userId});


  NoteModel.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    userId = map['userId'];
  }


  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'userId': userId,
    };
  }
}