import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:myapp/page_setting/feedback_vocabulary_screen.dart';

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
    double iconSize = screenWidth * 0.1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF154F41),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.vocabulary,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Spacer(), // Để dịch chuyển văn bản sang phải
                  Padding(
                    padding: const EdgeInsets.only(right: 27.0), // Điều chỉnh khoảng cách ở đây
                    child: Text(
                      '${word['korean']}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: titleFontSize * 1.5,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(2, 2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FeedbackVocabularyScreen(word: word),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: screenWidth * 0.35, // Kích thước của Icon
                      child: Icon(
                        Icons.feedback_outlined,
                        size: iconSize * 1.05,
                      ),
                    ),
                  ),
                ],
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
                          'assets/${AppLocalizations.of(context)!.localeName == 'en' ? 'english_flag.png' : AppLocalizations.of(context)!.localeName == 'ko' ? 'korean_flag.png' : 'vietnam_flag.png'}',
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
                                    '${AppLocalizations.of(context)!.localeName == 'en' ? word['english'] : AppLocalizations.of(context)!.localeName == 'ko' ? word['korean'] : word['vietnamese']}',
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
                                  _playAudio(AppLocalizations.of(context)!
                                      .localeName ==
                                      'en'
                                      ? word['voice_en']!
                                      : AppLocalizations.of(context)!
                                      .localeName ==
                                      'ko'
                                      ? word['voice_kr']!
                                      : word['voice_vn']!);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    if (AppLocalizations.of(context)!.localeName != 'ko')
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
                '${AppLocalizations.of(context)!.localeName == 'en' ? word['ex_en'] : AppLocalizations.of(context)!.localeName == 'ko' ? word['ex_kr'] : word['ex_vn']}',
                style: TextStyle(fontSize: titleFontSize * 1),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            if (AppLocalizations.of(context)!.localeName != 'ko')
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
              '${AppLocalizations.of(context)!.imageof} ${AppLocalizations.of(context)!.localeName == 'en' ? word['english'] : AppLocalizations.of(context)!.localeName == 'ko' ? word['korean'] : word['vietnamese']}',
              style: TextStyle(
                fontSize: titleFontSize * 0.8,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            SizedBox(
              height: imageContainerHeight,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(screenHeight *
                            0.03), // Điều chỉnh padding theo nhu cầu của bạn
                        child: Container(
                          width: imageSize * 1.5,
                          height: imageSize * 1,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius:
                            BorderRadius.circular(imageSize * 0.1),
                          ),
                          child: Image.network(
                            '${word['image']}',
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
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