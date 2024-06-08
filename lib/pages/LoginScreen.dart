import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/pages/home_screen.dart';
import 'package:myapp/pages/optSreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginscreen extends StatefulWidget {
  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final DatabaseReference _database = FirebaseDatabase.instance.reference().child('Account');
  Country selectedCountry = CountryParser.parseCountryCode('VN');
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
          // Handling the case if the database returns a List instead of a Map
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


  void _saveUserToDatabase(int uid, {int? phone, String? email}) async {
    int p =0;
    int status =1;
    await _database.child(uid.toString()).set({
      "Avatar": "",
      "Country": "",
      "Dob": "",
      "Email": email ?? "",
      "Fullname": "",
      "Gender": "",
      "Id": uid,
      "Phone": phone ?? p,
      "Status": status
    });
  }
  Future<bool> _isEmailExist(String email) async {
    final snapshot = await _database.orderByChild('Email').equalTo(email).once();
    return snapshot.snapshot.value != null;
  }
  Future<bool> _isPhoneExist(int phone) async {
    final snapshot = await _database.orderByChild('Phone').equalTo(phone).once();
    return snapshot.snapshot.value != null;
  }
  void sendOTP(BuildContext context) async {
    String phone = phoneController.text.trim();
    String fullPhoneNumber = "+${selectedCountry.phoneCode}$phone";

    // Kiểm tra định dạng số điện thoại
    String pattern = r'^\+?[0-9]{10,15}$'; // Ví dụ: kiểm tra số điện thoại có từ 10 đến 15 chữ số và có thể có dấu +
    RegExp regex = RegExp(pattern);
    print(fullPhoneNumber);
    if (fullPhoneNumber.isNotEmpty && regex.hasMatch(fullPhoneNumber)) {

      // Loại bỏ dấu "+" và chuyển đổi chuỗi số điện thoại thành số nguyên
      int phoneNumber = int.parse(fullPhoneNumber.replaceFirst('+', ''));
      bool phoneExists = await _isPhoneExist(phoneNumber);
      print(phoneExists);
      if (!phoneExists) {
        int newId = await _getNextUserId();
        _saveUserToDatabase(newId, phone: phoneNumber);
      }
      await _auth.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
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

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
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
          userId = newId;
        } else {
          DatabaseEvent event = await _database.orderByChild('Email').equalTo(email).once();
          DataSnapshot snapshot = event.snapshot;

          userId = -1; // default value
          if (snapshot.value != null) {
            if (snapshot.value is Map<dynamic, dynamic>) {
              Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
              values.forEach((key, value) {
                userId = value['Id'];
                print("userId : ${userId}");
              });
            } else if (snapshot.value is List) {
              List<dynamic> values = snapshot.value as List<dynamic>;
              for (var value in values) {
                if (value != null && value['Id'] != null) {
                  userId = value['Id'];
                  print("userId : ${userId}");
                  break;
                }
              }
            }
          }
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', userId);
        await _firebaseAuth.signInWithCredential(credential);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
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
      body: SingleChildScrollView(
        child: Center(
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
                              SizedBox(width: screenWidth * 0.025),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.01,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.05),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              hintText:
                                              'Enter your phone number...',
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              prefixIcon: Container(
                                                padding: const EdgeInsets.all(10.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    showCountryPicker(
                                                      context: context,
                                                      countryListTheme:
                                                      const CountryListThemeData(
                                                        bottomSheetHeight: 500,
                                                      ),
                                                      onSelect:
                                                          (Country country) {
                                                        setState(() {
                                                          selectedCountry =
                                                              country;
                                                        });
                                                      },
                                                    );
                                                  },
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        "${selectedCountry.flagEmoji}",
                                                        style: TextStyle(
                                                          fontSize: screenWidth * 0.05, // Adjust the size as needed
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        "+${selectedCountry.phoneCode}",
                                                        style: TextStyle(
                                                          fontSize: screenWidth * 0.04, // Adjust the size as needed
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            keyboardType: TextInputType.phone,
                                            controller: phoneController,
                                          ),
                                        ),
                                      ],
                                    ),
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
      ),
    );
  }
}