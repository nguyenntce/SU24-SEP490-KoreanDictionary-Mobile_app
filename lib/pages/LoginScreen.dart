import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/pages/home_screen.dart';
import 'package:myapp/pages/optSreen.dart';

class Loginscreen extends StatefulWidget {
  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
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
  Future<String?> _getUserIdByPhone(String phone) async {
    final snapshot = await _database.orderByChild('Phone').equalTo(phone).once();
    if (snapshot.snapshot.value != null) {
      var data = snapshot.snapshot.value as Map;
      var userId = data.keys.first;
      return userId;
    }
    return null;
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

  Future<bool> _isEmailExist(String email) async {
    final snapshot = await _database.orderByChild('Email').equalTo(email).once();
    return snapshot.snapshot.value != null;
  }

  Future<bool> _isPhoneExist(String phone) async {
    final snapshot = await _database.orderByChild('Phone').equalTo(phone).once();
    return snapshot.snapshot.value != null;
  }

  void sendOTP(BuildContext context) async {
    String phone = phoneController.text.trim();
    String fullPhoneNumber = "+${selectedCountry.phoneCode}$phone";

    String pattern = r'^\+?[0-9]{10,15}$';
    RegExp regex = RegExp(pattern);
    if (fullPhoneNumber.isNotEmpty && regex.hasMatch(fullPhoneNumber)) {
      String phoneNumber = fullPhoneNumber.replaceFirst('+', '');
      bool phoneExists = await _isPhoneExist(phoneNumber);

      if (!phoneExists) {
        int newId = await _getNextUserId();
        _saveUserToDatabase(newId, phone: phoneNumber);
        _saveSessionData(newId.toString());
        _auth.verifyPhoneNumber(
          phoneNumber: fullPhoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(uid: newId.toString())),
            );
          },
          verificationFailed: (FirebaseAuthException e) {
            Fluttertoast.showToast(msg: "Failed to Verify Phone Number: ${e.message}");
          },
          codeSent: (String verificationId, int? resendToken) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OptScreen(verificationId: verificationId, uid: newId.toString()),
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } else {
        String? existingUserId = await _getUserIdByPhone(phoneNumber);
        if (existingUserId != null) {
          _saveSessionData(existingUserId);
          _auth.verifyPhoneNumber(
            phoneNumber: fullPhoneNumber,
            verificationCompleted: (PhoneAuthCredential credential) async {
              await _auth.signInWithCredential(credential);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen(uid: existingUserId)),
              );
            },
            verificationFailed: (FirebaseAuthException e) {
              Fluttertoast.showToast(msg: "Failed to Verify Phone Number: ${e.message}");
            },
            codeSent: (String verificationId, int? resendToken) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OptScreen(verificationId: verificationId, uid: existingUserId),
                ),
              );
            },
            codeAutoRetrievalTimeout: (String verificationId) {},
          );
        }
      }
    } else {
      Fluttertoast.showToast(msg: "Please enter a valid phone number");
    }
  }

  void _saveSessionData(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
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
        if (!emailExists) {
          int newId = await _getNextUserId();
          _saveUserToDatabase(newId, email: googleSignInAccount.email);
          _saveSessionData(newId.toString());
        } else {
          final snapshot = await _database.orderByChild('Email').equalTo(email).once();
          if (snapshot.snapshot.value != null) {
            final userMap = snapshot.snapshot.value as Map<dynamic, dynamic>;
            String userId = userMap.keys.first.toString();
            _saveSessionData(userId);
          }
        }

        await _firebaseAuth.signInWithCredential(credential);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? uid = prefs.getString('uid');
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
                                              hintText: 'Enter your phone number...',
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: const BorderSide(color: Colors.black),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: const BorderSide(color: Colors.black),
                                              ),
                                              prefixIcon: Container(
                                                padding: const EdgeInsets.all(10.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    showCountryPicker(
                                                      context: context,
                                                      countryListTheme: const CountryListThemeData(
                                                        bottomSheetHeight: 500,
                                                      ),
                                                      onSelect: (Country country) {
                                                        setState(() {
                                                          selectedCountry = country;
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
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
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
