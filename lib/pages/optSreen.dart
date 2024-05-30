import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/pages/home_sreen.dart';
import 'package:pinput/pinput.dart';

class OptScreen extends StatelessWidget {
  final String verificationId;
  final TextEditingController otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  OptScreen({required this.verificationId});

  void verifyOTP(BuildContext context) async {
    String otp = otpController.text.trim();

    if (otp.isNotEmpty) {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      try {
        await _auth.signInWithCredential(credential);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context)=>HomeScreen()),
        );
      } catch (e) {
        Fluttertoast.showToast(msg: "Failed to sign in: $e");
      }
    } else {
      Fluttertoast.showToast(msg: "Please enter the OTP");
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
                        // SizedBox(height: screenWidth * 0.2),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                      ),
                      child: ElevatedButton(
                        onPressed:() => verifyOTP(context),
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
                onTap: () {
                  // Handle Google Sign In
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: screenWidth * 0.005,
                    ),
                    borderRadius: BorderRadius.circular(
                      screenWidth * 0.05,
                    ),
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
