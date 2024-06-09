import 'package:flutter/material.dart';
import 'package:myapp/pages/pages_menu/page_quiz/detailresult_quiz_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ResultQuizScreen extends StatefulWidget {
  final List<Map<String, dynamic>> results;

  const ResultQuizScreen({Key? key, required this.results}) : super(key: key);

  @override
  _ResultQuizScreenState createState() => _ResultQuizScreenState();
}

class _ResultQuizScreenState extends State<ResultQuizScreen> {
  late double _percent;
  late int _correctAnswers;
  late int _incorrectAnswers;

  @override
  void initState() {
    super.initState();
    _correctAnswers = widget.results.where((result) => result['isCorrect'] as bool).length;
    _incorrectAnswers = widget.results.length - _correctAnswers;
    _percent = _correctAnswers / widget.results.length;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleFontSize = screenWidth * 0.05;
    double indicatorSize = screenWidth * 0.2;
    double indicatorLineWidth = screenWidth * 0.021;
    double indicatorTextSize = screenWidth * 0.1;
    double editFontSize = screenWidth * 0.05;
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
          'Result',
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: kToolbarHeight + screenHeight * 0.1,
            left: screenWidth * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularPercentIndicator(
                  animation: true,
                  animationDuration: 1000,
                  radius: indicatorSize,
                  lineWidth: indicatorLineWidth,
                  percent: _percent,
                  progressColor: Colors.green,
                  backgroundColor: Colors.red,
                  circularStrokeCap: CircularStrokeCap.round,
                  center: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      '${(_percent * 100).toStringAsFixed(0)}%',
                      key: ValueKey<double>(_percent),
                      style: TextStyle(
                        fontSize: indicatorTextSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.08,
                ),
              ],
            ),
          ),
          Positioned(
            top: kToolbarHeight + screenHeight * 0.3,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  _percent >= 0.5 ? 'PASS' : 'NOT PASS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: editFontSize * 1.4,
                    fontWeight: FontWeight.w800,
                    color: _percent >= 0.5 ? Colors.green : Colors.red,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.15,
                  ),
                  child: const Divider(
                    color: Colors.black,
                    thickness: 2,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  'Correct: $_correctAnswers',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: editFontSize * 1.5,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 52, 238, 58),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  'Incorrect: $_incorrectAnswers',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: editFontSize * 1.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: screenHeight * 0.1), // Add some space
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF35FF3D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        side: const BorderSide(
                          width: 3,
                          color: Colors.white,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.01,
                        ),
                        child: Text(
                          'Restart',
                          style: TextStyle(
                            fontSize: titleFontSize * 1.2,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetailresultQuizScreen(results: widget.results),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF35FF3D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        side: const BorderSide(
                          width: 3,
                          color: Colors.white,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.07,
                          vertical: screenHeight * 0.01,
                        ),
                        child: Text(
                          'Detail',
                          style: TextStyle(
                            fontSize: titleFontSize * 1.2,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
