import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';



Future<void> saveTest(String testId, int accountId, int startDate, int endDate, int totalTime,String Created_date ) async {
  DatabaseReference ref = FirebaseDatabase.instance.reference().child('Test').child(testId);
  await ref.set({
    'Id':testId,
    'Account_Id': accountId,
    'Start_time': startDate,
    'End_time': endDate,
    'Total_time': totalTime,
    'Created_date':Created_date
  });
}

Future<void> saveQuestion(String questionId, String testId, int vocabularyId) async {
  DatabaseReference ref = FirebaseDatabase.instance.reference().child('Question').child(questionId);
  await ref.set({
    'Id':questionId,
    'Test_Id': testId,
    'Vocabulary_Id': vocabularyId,
  });
}

Future<void> saveHistory(String historyId, String questionId, int accountId, String answer, bool isCorrect) async {
  DatabaseReference ref = FirebaseDatabase.instance.reference().child('History').child(historyId);
  await ref.set({
    'Id':historyId,
    'Question_Id': questionId,
    'Account_Id': accountId,
    'Answer': answer,
    'Result': isCorrect,
  });
}
