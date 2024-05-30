import 'package:flutter/material.dart';
import 'dart:async';
import 'package:myapp/pages/pages_menu/page_quiz/detailresult_quiz_screen.dart';
import 'package:myapp/pages/pages_menu/page_quiz/result_quiz_screen.dart';

class ListenandfillwordScreen extends StatefulWidget {
  final int durationInSeconds;

  ListenandfillwordScreen(this.durationInSeconds);

  @override
  _ListenandfillwordScreenState createState() =>
      _ListenandfillwordScreenState();
}

class _ListenandfillwordScreenState extends State<ListenandfillwordScreen> {
  late Timer _timer;
  int _start = 0;

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
                    IconButton(
                      icon: Icon(
                        Icons.volume_up, // You can change the icon here
                        size: screenHeight * 0.2, // Adjust the size as needed
                        color: const Color.fromARGB(
                          255,
                          56,
                          71,
                          64,
                        ), // Change the color if needed
                      ),
                      onPressed: () {
                        // Add your onPressed functionality here
                        // For example, you can add code to play a sound
                        // or navigate to another screen
                      },
                    ),
                    SizedBox(
                      height: screenHeight *
                          0.00, // Add some spacing between the icon and text
                    ),
                    Text(
                      'Click The Icon To Hear The Sound', // Your text goes here
                      style: TextStyle(
                        fontSize:
                        textFontSize * 1, // Adjust the font size as needed
                        color: Colors.black, // Change the color if needed
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
                height: screenHeight * 0.02), // Khoảng cách giữa các phần tử
            // Hàng chứa hai hình ảnh
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Container cho hình ảnh 1
                  Container(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.2,
                    child: Image.asset(
                      'assets/correct_image1.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  // Container cho hình ảnh 2
                  Container(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.2,
                    child: Image.asset(
                      'assets/correct_image2.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ), // Khoảng cách giữa các phần tử
            // Container cho hình ảnh 3
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05), // Hàng chứa hai hình ảnh
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Container cho hình ảnh 1
                  Container(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.2,
                    child: Image.asset(
                      'assets/correct_image1.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  // Container cho hình ảnh 2
                  SizedBox(
                    width: screenWidth * 0.02,
                  ),
                  Container(
                      width: screenWidth * 0.4,
                      height: screenHeight * 0.2,
                      child: GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          'assets/correct_image1.png',
                          fit: BoxFit.fill,
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
                height: screenHeight * 0.05), // Khoảng cách giữa các phần tử
          ],
        ),
      ),
    );
  }
}