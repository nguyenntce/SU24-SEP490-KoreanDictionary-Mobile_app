import 'package:flutter/material.dart';
import 'dart:async';
import 'package:myapp/pages/pages_menu/page_quiz/detailresult_quiz_screen.dart';
import 'package:myapp/pages/pages_menu/page_quiz/result_quiz_screen.dart';

class PictureandchoosewordScreen extends StatefulWidget {
  final int durationInSeconds;

  PictureandchoosewordScreen(this.durationInSeconds);

  @override
  _ListenandfillwordScreenState createState() =>
      _ListenandfillwordScreenState();
}

class _ListenandfillwordScreenState extends State<PictureandchoosewordScreen> {
  late Timer _timer;
  int _start = 0;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _start = widget.durationInSeconds;
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
        // Kiểm tra nếu hết thời gian, thực hiện điều hướng tới trang mới
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) =>
                  DetailresultQuizScreen()), // Thay NewPage bằng tên trang bạn muốn chuyển đến
        );
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void stopTimer() {
    if (_timer.isActive) {
      setState(() {
        _timer.cancel();
      });
    }
  }

  void _togglePressed() {
    setState(() {
      _isPressed = !_isPressed;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleFontSize = screenWidth * 0.05;
    double textFontSize = screenWidth * 0.04;

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
                    'Question : 1/51',
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
                          borderRadius: BorderRadius.circular(screenHeight *
                              0.03), // Sử dụng phần trăm hoặc tỷ lệ để xác định góc bo tròn
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
                              formatTime(_start),
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
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => ResultQuizScreen(),
                            ),
                          );
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
                    Stack(
                      children: [
                        Image.asset(
                          'assets/wax_apple.png',
                          width: screenHeight * 0.2,
                          height: screenHeight * 0.2,
                          fit: BoxFit.fill,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.1), // Add some spacing
                    GestureDetector(
                      onTap: _togglePressed,
                      child: Container(
                        width: screenWidth * 0.6,
                        height: screenHeight * 0.05,
                        decoration: BoxDecoration(
                          color: _isPressed
                              ? const Color.fromARGB(255, 59, 238, 65)
                              : Colors.white, // Màu nền trắng
                          border: Border.all(color: Colors.black), // Viền đen
                          borderRadius: BorderRadius.circular(screenHeight *
                              0.025), // Sử dụng phần trăm hoặc tỷ lệ để xác định góc bo tròn
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'abv', // Nội dung văn bản
                              style: TextStyle(
                                fontSize:
                                    screenHeight * 0.025, // Kích thước văn bản
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Màu văn bản
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02), // Add some spacing
                    GestureDetector(
                      onTap: _togglePressed,
                      child: Container(
                        width: screenWidth * 0.6,
                        height: screenHeight * 0.05,
                        decoration: BoxDecoration(
                          color: _isPressed
                              ? const Color.fromARGB(255, 59, 238, 65)
                              : Colors.white, // Màu nền trắng
                          border: Border.all(color: Colors.black), // Viền đen
                          borderRadius: BorderRadius.circular(screenHeight *
                              0.025), // Sử dụng phần trăm hoặc tỷ lệ để xác định góc bo tròn
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'abv', // Nội dung văn bản
                              style: TextStyle(
                                fontSize:
                                    screenHeight * 0.025, // Kích thước văn bản
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Màu văn bản
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02), // Add some spacing
                    GestureDetector(
                      onTap: _togglePressed,
                      child: Container(
                        width: screenWidth * 0.6,
                        height: screenHeight * 0.05,
                        decoration: BoxDecoration(
                          color: _isPressed
                              ? const Color.fromARGB(255, 59, 238, 65)
                              : Colors.white, // Màu nền trắng
                          border: Border.all(color: Colors.black), // Viền đen
                          borderRadius: BorderRadius.circular(screenHeight *
                              0.025), // Sử dụng phần trăm hoặc tỷ lệ để xác định góc bo tròn
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'abv', // Nội dung văn bản
                              style: TextStyle(
                                fontSize:
                                    screenHeight * 0.025, // Kích thước văn bản
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Màu văn bản
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02), // Add some spacing
                    GestureDetector(
                      onTap: _togglePressed,
                      child: Container(
                        width: screenWidth * 0.6,
                        height: screenHeight * 0.05,
                        decoration: BoxDecoration(
                          color: _isPressed
                              ? const Color.fromARGB(255, 59, 238, 65)
                              : Colors.white, // Màu nền trắng
                          border: Border.all(color: Colors.black), // Viền đen
                          borderRadius: BorderRadius.circular(screenHeight *
                              0.025), // Sử dụng phần trăm hoặc tỷ lệ để xác định góc bo tròn
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'abv', // Nội dung văn bản
                              style: TextStyle(
                                fontSize:
                                    screenHeight * 0.025, // Kích thước văn bản
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Màu văn bản
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
