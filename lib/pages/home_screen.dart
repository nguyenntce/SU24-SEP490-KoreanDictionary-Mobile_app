import 'package:myapp/page_setting/setting_screen.dart';
import 'package:myapp/pages/pages_menu/camera_screen.dart';
import 'package:myapp/pages/pages_menu/quiz_screen.dart';
import 'package:myapp/pages/pages_menu/vocabulary_screen.dart';
import 'package:myapp/items/menu_item.dart';
import 'package:myapp/items/popular_item.dart';
import 'package:flutter/material.dart';
import '../pages/pages_menu/flashcard_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Tính toán padding và kích thước dựa trên kích thước màn hình
    double horizontalPadding = screenWidth * 0.03; // 5% của chiều rộng màn hình
    double verticalPadding = screenHeight * 0.02; // 2% của chiều cao màn hình
    double searchIconSize = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: Color(0xFFA4FFB3),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  children: [
                    SizedBox(height: verticalPadding),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Find Some New Word?',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.04, // Giảm kích thước chữ
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          // Giảm độ cong của viền
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2.5, // Giảm độ dày của viền
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 3.0, // Giảm độ dày của viền
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 3.0, // Giảm độ dày của viền
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          size: searchIconSize, // Giảm kích thước của icon
                        ),
                        contentPadding: EdgeInsets.fromLTRB(
                          screenWidth * 0.03, // Giảm lề ngang
                          screenWidth * 0.015, // Giảm lề dọc
                          screenWidth * 0.03, // Giảm lề ngang
                          screenWidth * 0.06, // Giảm lề dọc
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Container(
                      width: double.infinity,
                      height: screenHeight * 0.14,
                      // Chiều cao container dựa trên chiều cao màn hình
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
                            label: 'Camera',
                            destinationScreen: CameraScreen(),
                          ),
                          MenuItem(
                            imagePath: 'assets/vocabulary.png',
                            label: 'Vocabulary',
                            destinationScreen: VocabularyScreen(),
                          ),
                          MenuItem(
                            imagePath: 'assets/quiz.png',
                            label: 'Quiz',
                            destinationScreen: QuizScreen(),
                          ),
                          MenuItem(
                            imagePath: 'assets/flashcard.png',
                            label: 'Flashcard',
                            destinationScreen: FlashcardScreen(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: verticalPadding / 10),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: horizontalPadding / 10),
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            // Tính kích thước chữ dựa trên chiều rộng màn hình
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
                    SizedBox(height: verticalPadding / 10),
                    Container(
                      width: double.infinity,
                      height: screenHeight * 0.2,
                      // Chiều cao container dựa trên chiều cao màn hình
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
                    SizedBox(height: verticalPadding / 10),
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: horizontalPadding / 3,
                                bottom: verticalPadding / 3),
                            child: Text(
                              'Popular Word',
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                // Tính kích thước chữ dựa trên chiều rộng màn hình
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
                          SizedBox(height: verticalPadding / 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              PopularItem(),
                              PopularItem(),
                            ],
                          ),
                          SizedBox(height: verticalPadding / 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              PopularItem(),
                              PopularItem(),
                            ],
                          ),
                          SizedBox(height: verticalPadding / 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              PopularItem(),
                              PopularItem(),
                            ],
                          ),
                          
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Thêm footer là hình ảnh
          Container(
            width: double.infinity,
            child: Stack(
              children: [
                Image.asset(
                  'assets/footer_home.png',
                  width: screenWidth,
                  // Thay đường dẫn tới hình ảnh footer
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
                      width: screenWidth *
                          0.15, // Kích thước icon dựa trên chiều rộng màn hình
                    ),
                  ),
                ),
                Positioned(
                  bottom: screenHeight * 0.01,
                  left: screenWidth * 0.48 - (screenWidth * 0.15 / 2),
                  // Đặt vị trí ngang cho hình ảnh camera
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CameraScreen()));
                    },
                    child: Image.asset(
                      'assets/footer_camera.png',
                      width: screenWidth *
                          0.20, // Kích thước icon dựa trên chiều rộng màn hình
                    ),
                  ),
                ),
                Positioned(
                  bottom: screenHeight * 0.01,
                  left: screenWidth * 0.7,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingScreen()));
                    },
                    child: Image.asset(
                      'assets/setting.png',
                      width: screenWidth * 0.2,
                      // Kích thước icon dựa trên chiều rộng màn hình
                    ),
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
