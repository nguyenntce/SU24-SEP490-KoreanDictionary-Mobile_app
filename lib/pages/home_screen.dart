import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/page_setting/setting_screen.dart';
import 'package:myapp/pages/pages_menu/camera_screen.dart';
import 'package:myapp/pages/pages_menu/quiz_screen.dart';
import 'package:myapp/pages/pages_menu/vocabulary_screen.dart';
import 'package:myapp/items/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../pages/pages_menu/flashcard_screen.dart';
import 'package:myapp/pages/pages_menu/page_vocabulary/vocabulary_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference _database =
      FirebaseDatabase.instance.reference().child('Vocabulary');
  List<Map<String, String>> vocabulary = [];
  List<Map<String, String>> filteredVocabulary = [];
  List<Map<String, String>> randomVocabulary = [];
  TextEditingController searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _fetchVocabulary();
    searchController.addListener(_filterVocabulary);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterVocabulary);
    searchController.dispose();
    _focusNode.dispose();
    super.dispose();
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
          _getRandomVocabulary();
        });
      }
    });
  }
  void _getRandomVocabulary() {
    Random random = Random();
    if (vocabulary.length > 10) {
      Set<int> randomIndexes = {};
      while (randomIndexes.length < 10) {
        randomIndexes.add(random.nextInt(vocabulary.length));
      }
      randomVocabulary = randomIndexes.map((index) => vocabulary[index]).toList();
    } else {
      randomVocabulary = List.from(vocabulary);
    }
    filteredVocabulary = List.from(randomVocabulary);
    setState(() {});
  }
  void _filterVocabulary() {
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        filteredVocabulary = List.from(randomVocabulary);
      });
    } else {
      List<Map<String, String>> tempList = [];
      randomVocabulary.forEach((vocab) {
        if (vocab['english']!.toLowerCase().contains(query) ||
            vocab['korean']!.toLowerCase().contains(query) ||
            vocab['vietnamese']!.toLowerCase().contains(query)) {
          tempList.add(vocab);
        }
      });
      setState(() {
        filteredVocabulary = tempList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double horizontalPadding = screenWidth * 0.03;
    double verticalPadding = screenHeight * 0.02;

    return Scaffold(
      backgroundColor: Color(0xFFA4FFB3),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: verticalPadding),
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.findSomeNewWord,
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.025,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 3.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 3.0,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: screenWidth * 0.04,
                      ),
                      contentPadding: EdgeInsets.fromLTRB(
                        screenWidth * 0.015,
                        screenWidth * 0.0075,
                        screenWidth * 0.015,
                        screenWidth * 0.08,
                      ),
                    ),
                  ),
                  SizedBox(height: verticalPadding),
                  Container(
                    width: double.infinity,
                    height: screenHeight * 0.14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MenuItem(
                          imagePath: 'assets/camera.png',
                          label: AppLocalizations.of(context)!.camera,
                          destinationScreen: CameraScreen(),
                        ),
                        MenuItem(
                          imagePath: 'assets/vocabulary.png',
                          label: AppLocalizations.of(context)!.vocabulary,
                          destinationScreen: VocabularyScreen(),
                        ),
                        MenuItem(
                          imagePath: 'assets/quiz.png',
                          label: AppLocalizations.of(context)!.quiz,
                          destinationScreen: QuizScreen(),
                        ),
                        MenuItem(
                          imagePath: 'assets/flashcard.png',
                          label: AppLocalizations.of(context)!.flashcard,
                          destinationScreen: FlashcardScreen(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: verticalPadding / 5),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: horizontalPadding / 5),
                      child: Text(
                        AppLocalizations.of(context)!.getStarted,
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(0, 3),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: verticalPadding / 5),
                  Container(
                    width: double.infinity,
                    height: screenHeight * 0.17,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/image_home.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(height: verticalPadding / 7),
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: horizontalPadding / 3,
                              bottom: verticalPadding / 2),
                          child: Text(
                            AppLocalizations.of(context)!.popularWord,
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(0, 3),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: verticalPadding / 10),
                        _buildVocabularyList(screenWidth, screenHeight),
                        // Thêm các hàng khác tương tự ở đây
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: verticalPadding), // Add some bottom padding
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Image.asset(
              'assets/footer_home.png',
              width: screenWidth,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: screenHeight * 0.015,
              right: screenWidth * 0.7,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen()));
                },
                child: Image.asset(
                  'assets/footer_icon_home.png',
                  width: screenWidth * 0.15,
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.01,
              left: screenWidth * 0.48 - (screenWidth * 0.15 / 2),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CameraScreen()));
                },
                child: Image.asset(
                  'assets/footer_camera.png',
                  width: screenWidth * 0.20,
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.01,
              left: screenWidth * 0.7,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingScreen()));
                },
                child: Image.asset(
                  'assets/setting.png',
                  width: screenWidth * 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildVocabularyList(double screenWidth, double screenHeight) {
    List<Widget> rows = [];
    for (int i = 0; i < filteredVocabulary.length; i += 2) {
      rows.add(

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildVocabularyItem(filteredVocabulary[i], screenWidth, screenHeight),
            if (i + 1 < filteredVocabulary.length)
              _buildVocabularyItem(filteredVocabulary[i + 1], screenWidth, screenHeight),
          ],
        ),
      );
      rows.add(SizedBox(height: screenHeight * 0.02));
    }
    return Column(children: rows);
  }
  Widget _buildVocabularyItem(Map<String, String> vocab, double screenWidth, double screenHeight) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VocabularyDetailsScreen( word: vocab),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            width: screenWidth * 0.4,
            height: screenHeight * 0.1,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                right: screenWidth * 0.22,
                top: screenHeight * 0.01,
                bottom: screenHeight * 0.01,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  vocab['image']!,
                  fit: BoxFit.contain,
                  width: screenWidth * 0.15,
                  height: screenHeight * 0.1,
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.03,
            right: screenWidth * 0.03,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.localeName == 'en' ? vocab['english'] : AppLocalizations.of(context)!.localeName == 'ko' ? vocab['korean'] : vocab['vietnamese']}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if(AppLocalizations.of(context)!.localeName != 'ko')
                Text(
                  vocab['korean']!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
