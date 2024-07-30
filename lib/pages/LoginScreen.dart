import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/pages/home_screen.dart';
import 'package:myapp/pages/optSreen.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class Loginscreen extends StatefulWidget {
  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final DatabaseReference _database = FirebaseDatabase.instance.reference().child('Account');
  Country selectedCountry = CountryParser.parseCountryCode('VN');
  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16.0),
                Text("${AppLocalizations.of(context)!.loading}"),
              ],
            ),
          ),
        );
      },
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
  Future<bool> _isAccountLocked(String userId) async {
    final snapshot = await _database.child(userId).child('Status').once();
    if (snapshot.snapshot.value != null) {
      int status = snapshot.snapshot.value as int;
      return status != 1;
    }
    return false;
  }
  Future<int> _getNextUserId() async {
    int newId = 1;
    final event = await _database.orderByKey().limitToLast(1).once();
    final value = event.snapshot.value;
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
    return newId;
  }

  Future<String?> _getUserIdByPhone(String phone) async {
    final snapshot = await _database.orderByChild('Phone').equalTo(phone).once();
    if (snapshot.snapshot.value != null) {
      var data = snapshot.snapshot.value as Map;
      return data.keys.first;
    }
    return null;
  }

  Future<void> _saveUserToDatabase(int uid, {String? phone, String? email}) async {
    DateTime created_date = DateTime.now();
    String created_date_str = DateFormat('dd-MM-yyyy').format(created_date);
    int p = 0;
    int status = 1;
    await _database.child(uid.toString()).set({
      "Avatar": "https://firebasestorage.googleapis.com/v0/b/su24-sep490-koreandictionary.appspot.com/o/Avatar_img%2Favatar.jpg?alt=media&token=3a4716f2-c32b-428b-9489-4c8c7d01ef97",
      "Country": "",
      "Dob": "",
      "Email": email ?? "",
      "Fullname": "",
      "Gender": "",
      "Id": uid,
      "Phone": phone ?? p.toString(),
      "Status": status,
      "Created_date":created_date_str
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

  Future<int?> _getIdByPhone(String phone) async {
    final event = await _database.orderByChild('Phone').equalTo(phone).once();
    DataSnapshot snapshot = event.snapshot;
    if (snapshot.value != null) {
      if (snapshot.value is Map<dynamic, dynamic>) {
        return (snapshot.value as Map<dynamic, dynamic>).values.first['Id'];
      } else if (snapshot.value is List) {
        for (var value in snapshot.value as List) {
          if (value != null && value['Id'] != null) {
            return value['Id'];
          }
        }
      }
    }
    return null;
  }

  void sendOTP(BuildContext context) async {
    String phone = phoneController.text.trim();
    String fullPhoneNumber = "+${selectedCountry.phoneCode}$phone";
    String pattern = r'^\+?[0-9]{10,15}$';
    RegExp regex = RegExp(pattern);
    if (fullPhoneNumber.isNotEmpty && regex.hasMatch(fullPhoneNumber)) {
      showLoadingDialog(context);
      String phoneNumber = fullPhoneNumber.replaceFirst('+', '');
      bool phoneExists = await _isPhoneExist(phoneNumber);
      if (!phoneExists) {
        int newId = await _getNextUserId();
        _saveUserToDatabase(newId, phone: phoneNumber);
        _auth.verifyPhoneNumber(
          phoneNumber: fullPhoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            // await _auth.signInWithCredential(credential);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setInt('UID', newId);
            _saveSessionData(newId.toString());
            //hideLoadingDialog(context);
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => HomeScreen(uid: newId.toString())),
            // );
          },
          verificationFailed: (FirebaseAuthException e) {
            hideLoadingDialog(context);
            Fluttertoast.showToast(msg: "Failed to Verify Phone Number: ${e.message}");
          },
          codeSent: (String verificationId, int? resendToken) {
            hideLoadingDialog(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OptScreen(verificationId: verificationId, uid: newId.toString(),Fnumber:fullPhoneNumber),
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {hideLoadingDialog(context);},
        );
      } else {
        String? existingUserId = await _getUserIdByPhone(phoneNumber);
        int? userID = await _getIdByPhone(phoneNumber);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('UID', userID!);
        if (existingUserId != null) {
          bool isLocked = await _isAccountLocked(existingUserId);
          if (isLocked) {
            hideLoadingDialog(context);
            Fluttertoast.showToast(msg: "${AppLocalizations.of(context)!.accountislocked}");
            return;
          }
          _saveSessionData(existingUserId);
          _auth.verifyPhoneNumber(
            phoneNumber: fullPhoneNumber,
            timeout: Duration(seconds: 60),
            verificationCompleted: (PhoneAuthCredential credential) async {
              // await _auth.signInWithCredential(credential);
              // hideLoadingDialog(context);
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => HomeScreen(uid: existingUserId)),
              // );
            },
            verificationFailed: (FirebaseAuthException e) {
              hideLoadingDialog(context);
              Fluttertoast.showToast(msg: "${AppLocalizations.of(context)!.failedverifyphonenumber}");
            },
            codeSent: (String verificationId, int? resendToken) {
              hideLoadingDialog(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OptScreen(verificationId: verificationId, uid: existingUserId,Fnumber:fullPhoneNumber),
                ),
              );
            },
            codeAutoRetrievalTimeout: (String verificationId) {hideLoadingDialog(context);},
          );
        }
      }
    } else {
      Fluttertoast.showToast(msg: "${AppLocalizations.of(context)!.pleaseenteravalidphonenumber}");
    }
  }



  void _saveSessionData(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      showLoadingDialog(context);
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
          final event = await _database.orderByChild('Email').equalTo(email).once();
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
          bool isLocked = await _isAccountLocked(userId.toString());
          if (isLocked) {
            hideLoadingDialog(context);
            Fluttertoast.showToast(msg: "${AppLocalizations.of(context)!.accountislocked}");
            return;
          }
        }

        await _auth.signInWithCredential(credential);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String googleUid = _auth.currentUser?.uid ?? '';
        await prefs.setString('uid', googleUid);

        // Lấy uid từ SharedPreferences
        String? uid = prefs.getString('uid');
        await prefs.setInt('UID', userId);

        if (uid != null) {
          hideLoadingDialog(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(uid: uid)),
          );
        } else {
          hideLoadingDialog(context);
          Fluttertoast.showToast(msg: "${AppLocalizations.of(context)!.unknownerror}");
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "${AppLocalizations.of(context)!.unknownerror}");
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
                  AppLocalizations.of(context)!.welcomeback,
                  style: TextStyle(
                    fontSize: screenWidth * 0.1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  AppLocalizations.of(context)!.logintoyouraccount,
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
                                              hintText: '${AppLocalizations.of(context)!.pleaseenterphonenumber}',
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
                            AppLocalizations.of(context)!.wewillsendyouronetimepassword,
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
                        AppLocalizations.of(context)!.orsigninwith,
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
