import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/page_setting/profile_screen.dart';
import 'package:myapp/page_setting/language_screen.dart';
import 'package:myapp/pages/index.dart'; // Import the language screen
import 'package:myapp/page_setting/fag_screen.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool notificationsEnabled = true; // Trạng thái ban đầu là bật

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleFontSize = screenWidth * 0.05;
    double iconSize = screenWidth * 0.1;
    double containerHeight = screenHeight * 0.08;
    double imageContainerHeight = screenHeight * 0.1;
    double imageSize = screenWidth * 0.17;

    return Scaffold(
      backgroundColor: Color(0xFFA4FFB3),
      appBar: AppBar(
        backgroundColor: Color(0xFF154F41),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Setting',
          style: TextStyle(
            fontSize: titleFontSize * 1.5,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.00),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              height: imageContainerHeight,
              width: double.infinity,
              child: Row(
                children: [
                  SizedBox(width: screenWidth * 0.05),
                  Container(
                    width: imageSize,
                    height: imageSize,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/avatar.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(imageSize * 0.5),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Name',
                        style: TextStyle(
                          fontSize: titleFontSize * 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'User Email',
                        style: TextStyle(
                          fontSize: titleFontSize * 0.6,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()),
                      );
                    },
                    child: Icon(Icons.account_circle, size: iconSize * 1.3),
                  ),
                  SizedBox(width: screenWidth * 0.05),
                ],
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'General',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LanguageScreen(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: Colors.black),
                    ),
                    height: containerHeight,
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Row(
                        children: [
                          Icon(Icons.language, size: iconSize),
                          SizedBox(width: screenWidth * 0.05),
                          Text(
                            'Set Language',
                            style: TextStyle(
                              fontSize: titleFontSize * 0.8,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(child: Container()),
                          Icon(Icons.keyboard_arrow_right, size: iconSize),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      notificationsEnabled = !notificationsEnabled;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: Colors.black),
                    ),
                    height: containerHeight,
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Row(
                        children: [
                          Icon(Icons.notifications_active, size: iconSize),
                          SizedBox(width: screenWidth * 0.05),
                          Text(
                            'Notification',
                            style: TextStyle(
                              fontSize: titleFontSize * 0.8,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(child: Container()),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                notificationsEnabled = !notificationsEnabled;
                              });
                            },
                            child: Icon(
                              notificationsEnabled
                                  ? Icons.toggle_on
                                  : Icons.toggle_off,
                              size: iconSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Help',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: Colors.black),
                    ),
                    height: containerHeight,
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Row(
                        children: [
                          Icon(Icons.camera_alt, size: iconSize),
                          SizedBox(width: screenWidth * 0.05),
                          Text(
                            'How To Take A Picture',
                            style: TextStyle(
                              fontSize: titleFontSize * 0.8,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(child: Container()),
                          Icon(Icons.keyboard_arrow_right, size: iconSize),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: Colors.black),
                    ),
                    height: containerHeight,
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Row(
                        children: [
                          Icon(Icons.help, size: iconSize),
                          SizedBox(width: screenWidth * 0.05),
                          Text(
                            'Frequently Asked Questions',
                            style: TextStyle(
                              fontSize: titleFontSize * 0.8,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(child: Container()),
                          Icon(Icons.keyboard_arrow_right, size: iconSize),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FaqScreen(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: Colors.black),
                    ),
                    height: containerHeight,
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Row(
                        children: [
                          Icon(Icons.question_answer, size: iconSize),
                          SizedBox(width: screenWidth * 0.05),
                          Text(
                            'Feedback',
                            style: TextStyle(
                              fontSize: titleFontSize * 0.8,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(child: Container()),
                          Icon(Icons.keyboard_arrow_right, size: iconSize),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Information',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: Colors.black),
                    ),
                    height: containerHeight,
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Row(
                        children: [
                          Icon(Icons.share, size: iconSize),
                          SizedBox(width: screenWidth * 0.05),
                          Text(
                            'Share To Friends',
                            style: TextStyle(
                              fontSize: titleFontSize * 0.8,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(child: Container()),
                          Icon(Icons.keyboard_arrow_right, size: iconSize),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: Colors.black),
                    ),
                    height: containerHeight,
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Row(
                        children: [
                          Icon(Icons.star, size: iconSize),
                          SizedBox(width: screenWidth * 0.05),
                          Text(
                            'Rate App',
                            style: TextStyle(
                              fontSize: titleFontSize * 0.8,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(child: Container()),
                          Icon(Icons.keyboard_arrow_right, size: iconSize),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: Colors.black),
                    ),
                    height: containerHeight,
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Row(
                        children: [
                          Icon(Icons.info, size: iconSize),
                          SizedBox(width: screenWidth * 0.05),
                          Text(
                            'About Us',
                            style: TextStyle(
                              fontSize: titleFontSize * 0.8,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(child: Container()),
                          Icon(Icons.keyboard_arrow_right, size: iconSize),
                        ],
                      ),
                    ),
                  ),
                ),SizedBox(height: screenHeight * 0.02),
                GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => index()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: Colors.black),
                    ),
                    height: containerHeight,
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Row(
                        children: [
                          Icon(Icons.logout, size: iconSize),
                          SizedBox(width: screenWidth * 0.05),
                          Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: titleFontSize * 0.8,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(child: Container()),
                          Icon(Icons.keyboard_arrow_right, size: iconSize),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
        ],
      ),
      bottomNavigationBar: Container(
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
                  Navigator.pop(context);
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
                          builder: (context) => ProfileScreen()));
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingScreen()));
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
    );
  }
}
