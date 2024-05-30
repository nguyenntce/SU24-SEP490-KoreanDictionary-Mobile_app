import 'package:flutter/material.dart';
import 'package:myapp/pages/pages_menu/page_quiz/detailresult_quiz_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ResultQuizScreen extends StatefulWidget {
  @override
  _ResultQuizScreenState createState() => _ResultQuizScreenState();
}

class _ResultQuizScreenState extends State<ResultQuizScreen> {
  static const double _titleFontSizeRatio = 0.05;
  static const double _indicatorSizeRatio = 0.2;
  static const double _indicatorLineWidthRatio = 0.021;
  static const double _indicatorTextSizeRatio = 0.1;
  static const double _appBarHeight = kToolbarHeight;

  double _percent = 0.4; // Thay đổi giá trị percent tùy thuộc vào kết quả

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleFontSize = screenWidth * _titleFontSizeRatio;
    double indicatorSize = screenWidth * _indicatorSizeRatio;
    double indicatorLineWidth = screenWidth * _indicatorLineWidthRatio;
    double indicatorTextSize = screenWidth * _indicatorTextSizeRatio;
    double editFontSize = screenWidth * 0.05;
    return Scaffold(
      backgroundColor: const Color(0xFFA4FFB3),
      appBar: AppBar(
        backgroundColor: Color(0xFF154F41),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
            top: _appBarHeight + screenHeight * 0.1,
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
                    duration: Duration(milliseconds: 500),
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
            top: _appBarHeight + screenHeight * 0.3,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'NOT PASS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: editFontSize * 1.4,
                    fontWeight: FontWeight.w800,
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.15,
                  ),
                  child: Divider(
                    color: Colors.black,
                    thickness: 2,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  'Correct:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: editFontSize * 1.5,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 52, 238, 58),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  'Incorrect:',
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
                        // Code xử lý khi nhấn nút Restart
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF35FF3D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        side: BorderSide(
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
                        // Code xử lý khi nhấn nút Detail
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF35FF3D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        side: BorderSide(
                          width: 3,
                          color: Colors.white,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.07,
                          vertical: screenHeight * 0.01,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // Thực hiện hành động khi nhấn vào phần tử này
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailresultQuizScreen()),
                            );
                          },
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

