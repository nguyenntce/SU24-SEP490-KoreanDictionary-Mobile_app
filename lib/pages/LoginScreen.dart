import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/pages/optSreen.dart';
import 'package:myapp/pages/home_sreen.dart';
import 'package:country_picker/country_picker.dart';

class Loginscreen extends StatelessWidget{
  final TextEditingController phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void sendOTP(BuildContext context) async {
    String phone = phoneController.text.trim();

    // Kiểm tra định dạng số điện thoại
    String pattern = r'^\+?[0-9]{10,15}$'; // Ví dụ: kiểm tra số điện thoại có từ 10 đến 15 chữ số và có thể có dấu +
    RegExp regex = RegExp(pattern);

    if (phone.isNotEmpty && regex.hasMatch(phone)) {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          Fluttertoast.showToast(
              msg: "Failed to Verify Phone Number: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OptScreen(verificationId: verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } else {
      Fluttertoast.showToast(msg: "Please enter a valid phone number");
    }
  }
  Future<void> _signInWithGoogle(BuildContext context) async{
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if(googleSignInAccount != null ){
        final GoogleSignInAuthentication googleSignInAuthentication = await
        googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        await _firebaseAuth.signInWithCredential(credential);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => home_screen()),
        );
      }
    }catch(e) {
      String errorMessage = "Some error occurred: $e";
      Fluttertoast.showToast(msg: errorMessage);
      print(errorMessage);
    }


  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFA4FFB3),
      body: Center(
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
              SizedBox(height: screenHeight * 0.02),
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
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(screenWidth * 0.02),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: screenWidth * 0.008,
                                ),
                              ),
                              child: Icon(
                                Icons.phone,
                                color: Colors.black,
                                size: screenWidth * 0.1,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.025),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.005,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: screenWidth * 0.005,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    screenWidth * 0.05,
                                  ),
                                ),
                                child: TextField(
                                  controller: phoneController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your phone number...',
                                    hintStyle: TextStyle(
                                      fontSize: screenWidth * 0.045,
                                      color: Colors.black,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          'We will send your one time password (OTP)',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.1),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: screenHeight * 0.03,
                    left: 0,
                    right: screenWidth * 0.01,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                      ),
                      child: ElevatedButton(
                        onPressed: () => sendOTP(context),
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
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.01,
                    ),
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
                onTap: () => _signInWithGoogle(context),
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