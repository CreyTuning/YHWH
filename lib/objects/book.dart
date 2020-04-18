import 'package:yhwh/objects/chapter.dart';

class Book {
  String title = 'title';
  String description = 'description';
  String abbreviation = 'abbreviation';

  List<Chapter> chapters = List<Chapter>();

  Book({this.title, this.description, this.chapters});


  Future<void> fromMap(Map map) async
  {
    chapters = List<Chapter>();

    this.title = map['title'];
    this.title = map['description'];
    this.title = map['abbreviation'];

    for (int i = 0; i < map['chapters'].length; i++) {
      Chapter tempChapter = Chapter();
      await tempChapter.fromMap(map['chapters'][i]);

      chapters.add(tempChapter);
    }
  }
}