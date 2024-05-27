import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart'; // Import thư viện flip_card

class FlashcardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleFontSize = screenWidth * 0.05;

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
          'Flashcard',
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: PageView.builder(
          itemCount: 50,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
              // Tăng giá trị này để tăng padding
              child: FlipCard(
                direction: FlipDirection.HORIZONTAL,
                front: Container(
                  width: screenWidth,
                  height: screenHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 10,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.4,
                        child: Image.asset(
                          'assets/apple.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        'Apple',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '사과',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.10),
                      Container(
                        margin: EdgeInsets.only(top: screenHeight * 0.01),
                        child: Text(
                          'Click to see definition',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                back: Container(
                  width: screenWidth,
                  height: screenHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 10,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: screenHeight * 0.1,
                        child: Center(
                          child: Text(
                            '왁스 사과',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.08,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/english_flag.png',
                                    width: screenWidth * 0.16,
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.02,
                                  ),
                                  Container(
                                    width: screenWidth * 0.5,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Apple',
                                              style: TextStyle(
                                                fontSize: titleFontSize * 0.9,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          alignment: Alignment.centerRight,
                                          icon: Icon(
                                            Icons.volume_up,
                                            color: Colors.black,
                                            size: screenWidth * 0.1,
                                          ),
                                          onPressed: () {
                                            // Handle icon press
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/korean_flag.png',
                                    width: screenWidth * 0.16,
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.02,
                                  ),
                                  Container(
                                    width: screenWidth * 0.5,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '사과',
                                              style: TextStyle(
                                                fontSize: titleFontSize * 0.9,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          alignment: Alignment.centerRight,
                                          icon: Icon(
                                            Icons.volume_up,
                                            color: Colors.black,
                                            size: screenWidth * 0.1,
                                          ),
                                          onPressed: () {
                                            // Handle icon press
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(
                          'A small, round fruit with a thin, smooth, red purple or yellow skin, sweet, soft flesh, and a single large, hard seed.',
                          style: TextStyle(
                            fontSize: titleFontSize * 0.9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(
                          '얇고 매끄러운 붉은 보라색 또는 노란색 껍질, 달콤하고 부드러운 과육, 크고 단단한 씨앗 하나가 있는 작고 둥근 과일입니다.',
                          style: TextStyle(
                            fontSize: titleFontSize * 0.9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
