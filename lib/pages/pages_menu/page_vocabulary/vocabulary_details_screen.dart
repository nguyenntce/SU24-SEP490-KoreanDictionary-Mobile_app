import 'package:flutter/material.dart';

class VocabularyDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleFontSize = screenWidth * 0.05;
    double imageSize = screenWidth * 0.3;
    double imageContainerHeight = screenHeight * 0.25;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF154F41),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Vocabulary',
          style: TextStyle(
            fontSize: titleFontSize * 1.5,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),
            Center(
              child: Text(
                '왁스 사과',
                style: TextStyle(
                  fontSize: titleFontSize * 1.5,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(2, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/english_flag.png',
                          width: screenWidth * 0.2,
                        ),
                        Container(
                          width: screenWidth * 0.6,
                          child: Row(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Wax Apple',
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
                                  // Xử lý khi icon được nhấn vào
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      children: [
                        Image.asset(
                          'assets/korean_flag.png',
                          width: screenWidth * 0.2,
                        ),
                        Container(
                          width: screenWidth * 0.6,
                          child: Row(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '잠부 과일',
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
                                  // Xử lý khi icon được nhấn vào
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
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'A small, round fruit with a thin, smooth, red purple or yellow skin, sweet, soft flesh, and a single large, hard seed.',
                style: TextStyle(fontSize: titleFontSize * 1),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                '얇고 매끄러운 붉은 보라색 또는 노란색 껍질, 달콤하고 부드러운 과육, 크고 단단한 씨앗 하나가 있는 작고 둥근 과일입니다.',
                style: TextStyle(fontSize: titleFontSize * 1),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Image Of Wax Apple',
              style: TextStyle(
                fontSize: titleFontSize * 0.8,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              height: imageContainerHeight,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: imageSize * 1.3,
                        height: imageSize * 0.7,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(imageSize * 0.1),
                        ),
                        child: Image.asset(
                          'assets/wax_apple.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        width: imageSize * 1.3,
                        height: imageSize * 0.7,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(imageSize * 0.1),
                        ),
                        child: Image.asset(
                          'assets/wax_apple.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: imageSize * 1.3,
                        height: imageSize * 0.7,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(imageSize * 0.1),
                        ),
                        child: Image.asset(
                          'assets/wax_apple.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        width: imageSize * 1.3,
                        height: imageSize * 0.7,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(imageSize * 0.1),
                        ),
                        child: Image.asset(
                          'assets/wax_apple.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
