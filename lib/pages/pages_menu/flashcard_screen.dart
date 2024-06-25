import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart'; // Import thư viện flip_card
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class FlashcardScreen extends StatefulWidget {
  @override
  _FlashcardScreen createState() => _FlashcardScreen();
}

class _FlashcardScreen extends State<FlashcardScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.reference().child('Vocabulary');
  List<Map<String, String>> vocabulary = [];
  final AudioPlayer audioPlayer = AudioPlayer();
  final PageController _pageController = PageController(initialPage: 1); // Bắt đầu từ trang thứ 1
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _fetchVocabulary();
  }
  void _playAudio(String url) async {
    try {
      await audioPlayer.play(UrlSource(url)); // Sử dụng UrlSource cho URL

    } catch (e) {
      print('Error: $e');
      print(url);
    }
  }
  void _fetchVocabulary() {
    _database.onValue.listen((DatabaseEvent event) {
      final List<dynamic>? values = event.snapshot.value as List<dynamic>?;
      List<Map<String, String>> tempList = [];
      if (values != null) {
        values.forEach((value) {
          if (value != null) {
            tempList.add({
              'english': value['English'] ?? '',
              'korean': value['Korean'] ?? '',
              'vietnamese': value['Vietnamese'] ?? '',
              'image': value['Fruits_img'] ?? '',
              'voice_en': value['Voice_EN'] ?? '',
              'voice_kr': value['Voice_KR'] ?? '',
              'voice_vn': value['Voice_VN'] ?? '',
              'ex_en': value['Example_EN'] ?? '',
              'ex_kr': value['Example_KR'] ?? '',
              'ex_vn': value['Example_VN'] ?? '',
            });
          }
        });
        setState(() {
          vocabulary = tempList;
        });
      }
    });
  }

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
          AppLocalizations.of(context)!.flashcard,
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: vocabulary.isEmpty
                ? CircularProgressIndicator()
                : PageView.builder(
              controller: _pageController,
              itemCount: vocabulary.length + 2,
              onPageChanged: (index) {
                if (index == 0) {
                  _pageController.jumpToPage(vocabulary.length);
                } else if (index == vocabulary.length + 1) {
                  _pageController.jumpToPage(1);
                } else {
                  setState(() {
                    currentIndex = index - 1;
                  });
                }

              },
              itemBuilder: (context, index) {
                int displayIndex = index - 1;
                if (index == 0) {
                  displayIndex = vocabulary.length - 1;
                } else if (index == vocabulary.length + 1) {
                  displayIndex = 0;
                }
                var word = vocabulary[displayIndex];
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
                  child: FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    front: Container(
                      width: screenWidth,
                      height: screenHeight * 0.7,
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
                            height: screenHeight * 0.3,
                            child: Image.network(
                              word['image']!,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            AppLocalizations.of(context)!.localeName == 'en'
                                ? word['english']!
                                : AppLocalizations.of(context)!.localeName == 'ko'
                                ? word['korean']!
                                : word['vietnamese']!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth * 0.12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (AppLocalizations.of(context)!.localeName != 'ko')
                            Text(
                              word['korean']!,
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
                              AppLocalizations.of(context)!.click_to_see_definition,
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
                      height: screenHeight * 0.7,
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
                                AppLocalizations.of(context)!.localeName == 'en'
                                    ? word['english']!
                                    : AppLocalizations.of(context)!.localeName == 'ko'
                                    ? word['korean']!
                                    : word['vietnamese']!,
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
                                        AppLocalizations.of(context)!.localeName == 'ko'
                                            ? 'assets/korean_flag.png'
                                            : AppLocalizations.of(context)!.localeName == 'en'
                                            ? 'assets/english_flag.png'
                                            : 'assets/vietnam_flag.png',
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
                                                  AppLocalizations.of(context)!.localeName == 'en'
                                                      ? word['english']!
                                                      : AppLocalizations.of(context)!.localeName == 'ko'
                                                      ? word['korean']!
                                                      : word['vietnamese']!,
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
                                                _playAudio(AppLocalizations.of(context)!.localeName == 'en' ? word['voice_en']! : AppLocalizations.of(context)!.localeName == 'ko' ? word['voice_kr']! : word['voice_vn']!);

                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  if (AppLocalizations.of(context)!.localeName != 'ko')
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
                                                    word['korean']!,
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
                          SizedBox(height: screenHeight * 0.05),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text(
                              AppLocalizations.of(context)!.localeName == 'en'
                                  ? word['ex_en']!
                                  : AppLocalizations.of(context)!.localeName == 'ko'
                                  ? word['ex_kr']!
                                  : word['ex_vn']!,
                              style: TextStyle(
                                fontSize: titleFontSize * 0.9,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          if (AppLocalizations.of(context)!.localeName != 'ko')
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Text(
                                word['ex_kr']!,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              '${currentIndex + 1}/${vocabulary.length}',
              style: TextStyle(
                fontSize: titleFontSize * 1,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: screenHeight * 0.01), // Adjust the height as neede
        ],

      ),
    );
  }
}
