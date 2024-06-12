import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/pages/home_screen.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OptScreen extends StatelessWidget {
  final String verificationId;
  final String uid; // Add this line
  final TextEditingController otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final DatabaseReference _database = FirebaseDatabase.instance.reference().child('Account');

  OptScreen({required this.verificationId, required this.uid}); // Modify the constructor

  void verifyOTP(BuildContext context) async {
    String otp = otpController.text.trim();

    if (otp.isNotEmpty) {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      try {
        await _auth.signInWithCredential(credential);
        // Save UID to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', uid);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(uid: uid)), // Use the passed uid here
        );
      } catch (e) {
        Fluttertoast.showToast(msg: "Failed to sign in: $e");
      }
    } else {
      Fluttertoast.showToast(msg: "Please enter the OTP");
    }
  }
  Future<int> _getNextUserId() async {
    int newId = 1;
    await _database.orderByKey().limitToLast(1).once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        var value = event.snapshot.value;
        if (value is Map) {
          value.forEach((key, value) {
            if (value != null && value is Map && value.containsKey('Id')) {
              var lastId = value['Id'] as int;
              newId = lastId + 1;
            }
          });
        } else if (value is List) {
          for (var entry in value) {
            if (entry != null && entry is Map && entry.containsKey('Id')) {
              var lastId = entry['Id'] as int;
              newId = lastId + 1;
            }
          }
        }
      }
    });
    return newId;
  }
  Future<bool> _isEmailExist(String email) async {
    final snapshot = await _database.orderByChild('Email').equalTo(email).once();
    return snapshot.snapshot.value != null;
  }
  void _saveSessionData(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);

  }
  void _saveUserToDatabase(int uid, {String? phone, String? email}) async {
    int p = 0;
    int status = 1;
    await _database.child(uid.toString()).set({
      "Avatar": "",
      "Country": "",
      "Dob": "",
      "Email": email ?? "",
      "Fullname": "",
      "Gender": "",
      "Id": uid,
      "Phone": phone ?? p.toString(),
      "Status": status
    });
  }
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        String email = googleSignInAccount.email;
        bool emailExists = await _isEmailExist(email);
        int userId;
        if (!emailExists) {
          int newId = await _getNextUserId();
          _saveUserToDatabase(newId, email: googleSignInAccount.email);
          _saveSessionData(newId.toString());
          userId = newId;

        } else {
          userId = -1;
          final event  = await _database.orderByChild('Email').equalTo(email).once();
          DataSnapshot snapshot = event.snapshot;
          if (snapshot.value != null) {
            if (snapshot.value is Map<dynamic, dynamic>) {
              Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
              values.forEach((key, value) {
                userId = value['Id'];

              });
            } else if (snapshot.value is List) {
              List<dynamic> values = snapshot.value as List<dynamic>;
              for (var value in values) {
                if (value != null && value['Id'] != null) {
                  userId = value['Id'];

                  break;
                }
              }
            }
          }
          if (event.snapshot.value != null) {
            final userMap = event.snapshot.value as Map<dynamic, dynamic>;
            String userId = userMap.keys.first.toString();
            _saveSessionData(userId);
          }

        }

        await _firebaseAuth.signInWithCredential(credential);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? uid = prefs.getString('uid');
        await prefs.setInt('UID', userId);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(uid: uid!)),
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Some error occurred: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final defaultPinTheme = PinTheme(
      width: screenWidth * 0.12,
      height: screenHeight * 0.07,
      textStyle: TextStyle(
        fontSize: screenWidth * 0.05,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xFFA4FFB3),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.05,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: screenWidth * 0.1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'Login To Your Account',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Image.asset(
                'assets/avocado.png',
                height: screenHeight * 0.08,
              ),
              SizedBox(height: screenHeight * 0.01),
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.06,
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/backgroundwhite.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: screenHeight * 0.2),
                      ],
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.02, // Đặt vị trí của dòng text
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'Confirm OTP',
                            style: TextStyle(
                              fontSize: screenWidth * 0.08,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.001),
                          Text(
                            'Enter the OTP sent to - xxxxxxxxxxx',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Pinput(
                            length: 6,
                            showCursor: true,
                            controller: otpController,
                            onCompleted: (pin) => print(pin),
                            defaultPinTheme: defaultPinTheme,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: screenHeight * 0.01,
                    left: 0,
                    right: screenWidth * 0.01,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                      child: ElevatedButton(
                        onPressed: () => verifyOTP(context),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          shape: CircleBorder(),
                          backgroundColor: Color(0xFFA9FF54),
                          elevation: 1,
                          side: BorderSide(
                            color: Colors.black,
                            width: screenWidth * 0.006,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          size: screenWidth * 0.1,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                      height: screenHeight * 0.04,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                    child: Text(
                      'Or Sign In With',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                      height: screenHeight * 0.05,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.08),
              GestureDetector(
                onTap: () {
                  _signInWithGoogle(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: screenWidth * 0.005,
                    ),
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                  child: Image.asset(
                    'assets/google_logo.png',
                    height: screenHeight * 0.15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}