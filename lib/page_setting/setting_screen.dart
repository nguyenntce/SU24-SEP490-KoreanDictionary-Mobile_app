  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:firebase_database/firebase_database.dart';
  import 'package:flutter/material.dart';
  import 'package:google_sign_in/google_sign_in.dart';
  import 'package:myapp/page_setting/aboutus_screen.dart';
  import 'package:myapp/page_setting/feedback_screen.dart';
  import 'package:myapp/page_setting/profile_screen.dart';
  import 'package:myapp/page_setting/language_screen.dart';
  import 'package:myapp/pages/index.dart'; // Import the language screen
  import 'package:myapp/page_setting/fag_screen.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  
  class SettingScreen extends StatefulWidget {
    @override
    _SettingScreenState createState() => _SettingScreenState();
  }
  
  class _SettingScreenState extends State<SettingScreen> {
    bool notificationsEnabled = true;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    User? _currentUser;
    DatabaseReference _database = FirebaseDatabase.instance.reference().child('Account');
    String _username = '';
    String _email = '';
    String _accountId = '';
  
    @override
    void initState() {
      super.initState();
      _getCurrentUser();
    }
    Future<void> _getCurrentUser() async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          _currentUser = user;
          _email = user.email ?? '';
        });
  
        // Fetch user data from Firebase Realtime Database by Email
        DatabaseEvent emailEvent = await _database.orderByChild('Email').equalTo(user.email).once();
        DataSnapshot emailSnapshot = emailEvent.snapshot;
        if (emailSnapshot.exists) {
          Map<String, dynamic> userData = Map<String, dynamic>.from(emailSnapshot.value as Map);
          userData.forEach((key, value) {
            setState(() {
              _username = value['Fullname'] ?? '';
              _accountId = key;
            });
          });
        } else {
          // Fetch user data from Firebase Realtime Database by Phone
          String phoneNumber = user.phoneNumber!.replaceAll('+', '');
          DatabaseEvent phoneEvent = await _database.orderByChild('Phone').equalTo(phoneNumber).once();
          DataSnapshot phoneSnapshot = phoneEvent.snapshot;
          if (phoneSnapshot.exists) {
            Map<String, dynamic> userData = Map<String, dynamic>.from(phoneSnapshot.value as Map);
            userData.forEach((key, value) {
              setState(() {
                _username = value['Fullname'] ?? '';
                _accountId = key;
              });
            });
          }
        }
  
        // Save account ID to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accountId', _accountId);
      } else {
        // Load account ID from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        setState(() {
          _accountId = prefs.getString('accountId') ?? '';
        });
      }
    }
    Future<void> _signOut(BuildContext context) async {
      try {
        if (_currentUser != null) {
          if (_currentUser!.providerData.any((userInfo) => userInfo.providerId == 'google.com')) {
            await _googleSignIn.signOut();
          }
          await FirebaseAuth.instance.signOut();
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => index()),
        );
      } catch (e) {
        print("Error signing out: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: $e')),
        );
      }
    }
  
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
                          image: AssetImage('assets/duahau.png'),
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
                          _username,
                          style: TextStyle(
                            fontSize: titleFontSize * 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _email,
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
                            builder: (context) => ProfileScreen(uid: _accountId, isGoogleSignIn: _currentUser!.providerData.any((userInfo) => userInfo.providerId == 'google.com')),
                          ),
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
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                                notificationsEnabled ? Icons.toggle_on : Icons.toggle_off,
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
                          builder: (context) => ProfileScreen(uid: _accountId, isGoogleSignIn: _currentUser!.providerData.any((userInfo) => userInfo.providerId == 'google.com')),
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
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                          builder: (context) => FeedbackScreen(),
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
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                          builder: (context) => ProfileScreen(uid: _accountId, isGoogleSignIn: _currentUser!.providerData.any((userInfo) => userInfo.providerId == 'google.com')),
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
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                          builder: (context) => ProfileScreen(uid: _accountId, isGoogleSignIn: _currentUser!.providerData.any((userInfo) => userInfo.providerId == 'google.com')),
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
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                          builder: (context) => AboutusScreen(),
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
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  GestureDetector(
                    onTap: () => _signOut(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(color: Colors.black),
                      ),
                      height: containerHeight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                  // onTap: () {
                  //   Navigator.of(context).push(
                  //     MaterialPageRoute(
                  //       builder: (context) => HomeScreen(),
                  //     ),
                  //   );
                  // },
                  child: Image.asset(
                    'assets/footer_icon_home.png',
                    width: screenWidth * 0.15, // Kích thước icon dựa trên chiều rộng màn hình
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
                      MaterialPageRoute(builder: (context) => ProfileScreen(uid: _accountId, isGoogleSignIn: _currentUser!.providerData.any((userInfo) => userInfo.providerId == 'google.com'))),
                    );
                  },
                  child: Image.asset(
                    'assets/footer_camera.png',
                    width: screenWidth * 0.20, // Kích thước icon dựa trên chiều rộng màn hình
                  ),
                ),
              ),
              Positioned(
                bottom: screenHeight * 0.01,
                left: screenWidth * 0.7,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
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
