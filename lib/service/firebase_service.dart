import 'package:firebase_database/firebase_database.dart';



Future<void> saveTest(String testId, int accountId, int startDate, int endDate, int totalTime) async {
  DatabaseReference ref = FirebaseDatabase.instance.reference().child('Test').child(testId);
  await ref.set({
    'Account_Id': accountId,
    'Start_date': startDate,
    'End_date': endDate,
    'Total_time': totalTime,
  });
}

Future<void> saveQuestion(String questionId, String testId, int vocabularyId) async {
  DatabaseReference ref = FirebaseDatabase.instance.reference().child('Question').child(questionId);
  await ref.set({
    'Test_Id': testId,
    'Vocabulary_Id': vocabularyId,
  });
}

Future<void> saveHistory(String historyId, String questionId, int accountId, String answer, bool isCorrect) async {
  DatabaseReference ref = FirebaseDatabase.instance.reference().child('History').child(historyId);
  await ref.set({
    'Question_Id': questionId,
    'Account_Id': accountId,
    'Answer': answer,
    'Result': isCorrect,
  });
}
