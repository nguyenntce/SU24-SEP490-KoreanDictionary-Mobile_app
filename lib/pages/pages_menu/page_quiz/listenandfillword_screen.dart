import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:myapp/models/vocabulary.dart';
import 'package:myapp/models/vocabulary_service.dart'; // Import file chứa hàm getRandomVocabularies
import 'package:myapp/pages/pages_menu/page_quiz/detailresult_quiz_screen.dart';
import 'package:myapp/pages/pages_menu/page_quiz/result_quiz_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:myapp/service/firebase_service.dart';
import 'package:myapp/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListenandfillwordScreen extends StatefulWidget {
  final int durationInSeconds;

  ListenandfillwordScreen(this.durationInSeconds);

  @override
  _ListenandfillwordScreenState createState() => _ListenandfillwordScreenState();
}

class _ListenandfillwordScreenState extends State<ListenandfillwordScreen> {
  late Timer _timer;
  late AudioPlayer _audioPlayer;
  int _totalTime = 0;
  int _timePerQuestion = 30; // 30 seconds per question
  int _currentQuestionIndex = 0;
  int _selectedAnswer = -1;
  List<Vocabulary> _vocabularies = [];
  bool _showCorrectAnswer = false;
  List<Map<String, dynamic>> _results = [];
  List<Vocabulary> _currentOptions = [];
  String testId = '';
  int accountId = 0;
  int startTime = 0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _totalTime = widget.durationInSeconds;
    startTime = DateTime.now().millisecondsSinceEpoch;
    startTimer();
    _loadVocabularies();
    _initUserId();
    testId = generateUniqueId();
  }
  Future<void> _initUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accountId = prefs.getInt('UID') ?? 0;
  }
  Future<void> _loadVocabularies() async {
    int numberOfQuestions = widget.durationInSeconds ~/ _timePerQuestion;
    List<Vocabulary> vocabularies = await getRandomVocabularies(numberOfQuestions);
    setState(() {
      _vocabularies = vocabularies;
      _setCurrentOptions();
    });
  }

  void _setCurrentOptions() {
    if (_currentQuestionIndex < _vocabularies.length) {
      List<Vocabulary> tempList = List.from(_vocabularies);
      Vocabulary correctAnswer = tempList.removeAt(_currentQuestionIndex);
      tempList.shuffle();
      List<Vocabulary> wrongAnswers = tempList.take(3).toList();
      wrongAnswers.add(correctAnswer);
      wrongAnswers.shuffle();
      setState(() {
        _currentOptions = wrongAnswers;
      });
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_totalTime == 0) {
          timer.cancel();
          _navigateToResultScreen();
        } else {
          _totalTime--;
          if (_totalTime % _timePerQuestion == 0) {
            _nextQuestion();
          }
        }
      });
    });
  }

  void stopTimer() {
    if (_timer.isActive) {
      setState(() {
        _timer.cancel();
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _nextQuestion()  async{
    if (_selectedAnswer != -1) {
      Vocabulary currentVocabulary = _vocabularies[_currentQuestionIndex];
      Vocabulary selectedVocabulary = _currentOptions[_selectedAnswer];
      // Lưu dữ liệu câu trả lời vào Firebase
      String historyId = generateUniqueId();
      String questionId = generateUniqueId();

      await saveQuestion(
      questionId,
      testId,
      currentVocabulary.id,
      );

      await saveHistory(
      historyId,
      questionId,
      accountId,
      selectedVocabulary.korean,
      currentVocabulary.image == selectedVocabulary.image,
      );
      _results.add({
        'vietnamese':currentVocabulary.vietnamese,
        'english': currentVocabulary.english,
        'korean': currentVocabulary.korean,
        'image': currentVocabulary.image,
        'answer': selectedVocabulary.image,
        'answerEN': selectedVocabulary.english,
        'answerVN': selectedVocabulary.vietnamese,
        'answerKR': selectedVocabulary.korean,
        'voiceVN':currentVocabulary.voiceVn,
        'voiceKo':currentVocabulary.voiceKr,
        'voiceEn': currentVocabulary.voiceEn,
        'isCorrect': currentVocabulary.image == selectedVocabulary.image,
      });
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = -1;
        _showCorrectAnswer = false;
        if (_currentQuestionIndex < _vocabularies.length) {
          _setCurrentOptions();
        } else {
          stopTimer();
          _navigateToResultScreen();
        }
      });
    }
  }

  void _navigateToResultScreen() async  {
    int endTime = DateTime.now().millisecondsSinceEpoch;
    int elapsedTime = (endTime - startTime) ~/ 1000; // Thời gian kết thúc
    await saveTest(
      testId,
      accountId,
      0,
      elapsedTime,
      widget.durationInSeconds,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => ResultQuizScreen(results: _results)),
    );
  }

  void _playAudio(String url) async {
    await _audioPlayer.stop(); // Stop any currently playing audio
    await _audioPlayer.play(UrlSource(url)); // Play the new audio
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleFontSize = screenWidth * 0.05;
    double textFontSize = screenWidth * 0.04;

    if (_vocabularies.isEmpty || _currentOptions.isEmpty) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    Vocabulary currentVocabulary = _vocabularies[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFA4FFB3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF154F41),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Listen And Fill Word',
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.03,
                vertical: screenHeight * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question : ${_currentQuestionIndex + 1}/${_vocabularies.length}',
                    style: TextStyle(
                      fontSize: textFontSize * 1.2,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenHeight * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 67, 235, 72),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time_filled_sharp,
                              color: Colors.grey,
                              size: textFontSize * 1.5,
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Text(
                              formatTime(_totalTime),
                              style: TextStyle(
                                fontSize: textFontSize * 1.2,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.05),
                      ElevatedButton(
                        onPressed: () {
                          stopTimer();
                          _navigateToResultScreen();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text(
                          'Stop',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: textFontSize * 1.2,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.00),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenHeight * 0.05,
                  vertical: screenWidth * 0.04,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.volume_up, // Biểu tượng loa
                        size: screenHeight * 0.2, // Kích thước biểu tượng
                        color: const Color.fromARGB(
                          255,
                          56,
                          71,
                          64,
                        ), // Màu sắc của biểu tượng
                      ),
                      onPressed: () {
                        String audioUrl = AppLocalizations.of(context)!.localeName == 'en'
                            ? currentVocabulary.voiceEn
                            : AppLocalizations.of(context)!.localeName == 'ko'
                            ? currentVocabulary.voiceKr
                            : currentVocabulary.voiceVn;
                        _playAudio(audioUrl);
                      },
                    ),
                    SizedBox(
                      height: screenHeight *
                          0.00, // Khoảng cách giữa biểu tượng và văn bản
                    ),
                    Text(
                      'Click The Icon To Hear The Sound', // Văn bản hiển thị
                      style: TextStyle(
                        fontSize:
                        textFontSize * 1, // Kích thước văn bản
                        color: Colors.black, // Màu sắc văn bản
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Khoảng cách giữa các phần tử
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                children: List.generate(2, (rowIndex) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(2, (colIndex) {
                        int answerIndex = rowIndex * 2 + colIndex;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedAnswer = answerIndex;
                            });
                            _nextQuestion();
                          },
                          child: Container(
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.2,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _selectedAnswer == answerIndex
                                    ? Colors.blue
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Image.network(
                              _currentOptions[answerIndex].image,
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Khoảng cách giữa các phần tử
          ],
        ),
      ),
    );
  }
}
