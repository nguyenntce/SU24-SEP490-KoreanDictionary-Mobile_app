import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/models/vocabulary.dart'; // Đảm bảo rằng bạn đã import class Vocabulary

Future<List<Vocabulary>> getRandomVocabularies(int numberOfQuestions) async {
  DatabaseEvent event = await FirebaseDatabase.instance.reference().child('Vocabulary').once();
  DataSnapshot snapshot = event.snapshot;
  List<Vocabulary> vocabularies = [];
  if (snapshot.value != null) {
    if (snapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, value) {
        vocabularies.add(Vocabulary.fromMap(value));
      });
    } else if (snapshot.value is List) {
      List<dynamic> values = snapshot.value as List<dynamic>;
      for (var value in values) {
        if (value != null) {
          vocabularies.add(Vocabulary.fromMap(value));
        }
      }
    }
  }

  // Chọn ngẫu nhiên số lượng câu hỏi mong muốn
  vocabularies.shuffle();
  return vocabularies.take(numberOfQuestions).toList();
}
