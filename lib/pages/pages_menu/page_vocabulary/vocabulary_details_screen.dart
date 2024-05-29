import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class VocabularyDetailsScreen extends StatelessWidget {
  final Map<String, String> word;
  final AudioPlayer audioPlayer = AudioPlayer();
  VocabularyDetailsScreen({required this.word});
  void _playAudio(String url) async {
    try {
      await audioPlayer.play(UrlSource(url)); // Sử dụng UrlSource cho URL

    } catch (e) {
      print('Error: $e');
      print(url);
    }
  }
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
                                    '${word['english']}',
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
                                  _playAudio(word['voice_en']!);
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
                                    '${word['korean']}',
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
                                  _playAudio(word['voice_kr']!);
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
                '${word['ex_en']}',
                style: TextStyle(fontSize: titleFontSize * 1),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                '${word['ex_kr']}',
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
                        child: Image.network(
                          '${word['image']}',
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
