import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileScreen extends StatefulWidget {
  final String uid; // Pass the user ID when creating the ProfileScreen
  final bool isGoogleSignIn;

  ProfileScreen({required this.uid, required this.isGoogleSignIn});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _gender = 'Male';

  final DatabaseReference _database = FirebaseDatabase.instance.reference().child('Account');

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    try {
      print('Loading user data for uid: ${widget.uid}');
      DatabaseEvent event = await _database.child(widget.uid).once();
      DataSnapshot snapshot = event.snapshot;
      print('Snapshot data: ${snapshot.value}');

      if (snapshot.exists) {
        var userData = snapshot.value as Map;
        _populateUserData(Map<String, dynamic>.from(userData));
      } else {
        print('No data exists for the user with uid: ${widget.uid}');
      }
    } catch (e) {
      print('Failed to load user data: $e');
    }
  }

  void _populateUserData(Map<String, dynamic> userData) {
    setState(() {
      _fullnameController.text = userData['Fullname'] ?? '';
      _dobController.text = userData['Dob'] ?? '';
      _emailController.text = userData['Email'] ?? '';
      _phoneController.text = userData['Phone']?.toString() ?? '';
      _addressController.text = userData['Country'] ?? '';
      _gender = ['Male', 'Female', 'Other'].contains(userData['Gender']) ? userData['Gender'] : 'Male';
    });
  }

  void _saveUserToDatabase(String uid, {String? phone, String? email}) async {
    try {
      await _database.child(uid).update({
        "Avatar": "",
        "Country": _addressController.text,
        "Dob": _dobController.text,
        "Email": email ?? _emailController.text,
        "Fullname": _fullnameController.text,
        "Gender": _gender,
        "Phone": phone ?? _phoneController.text,
        "Status": 1,
      });
      print('User data updated successfully');
    } catch (e) {
      print('Failed to save user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleFontSize = screenWidth * 0.05;
    double containerHeight = screenHeight * 0.08;
    double imageContainerHeight = screenHeight * 0.1;
    double imageSize = screenWidth * 0.17;
    double iconSize = screenWidth * 0.12;

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
          'Profile',
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
              height: imageContainerHeight * 1.8,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Container()), // Container trống để căn giữa hình ảnh
                  Container(
                    width: imageSize * 1.5, // Tăng kích thước của hình ảnh lên
                    height: imageSize * 1.5, // Tăng kích thước của hình ảnh lên
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Đảm bảo hình ảnh là hình tròn
                      border: Border.all(
                        color: Colors.white, // Màu viền trắng
                        width: 3.0, // Độ dày của viền
                      ),
                      image: DecorationImage(
                        image: AssetImage('assets/duahau.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    padding: EdgeInsets.all(4.0), // Tạo viền bằng cách thêm padding
                  ),
                  Expanded(child: Container()), // Container trống để căn giữa hình ảnh
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
                  'Fullname',
                  style: TextStyle(
                    fontSize: titleFontSize * 1.2,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Container(
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
                        Expanded(
                          child: TextField(
                            controller: _fullnameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '---------------',
                              hintStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey, // Light grey color for hint text
                              ),
                            ),
                          ),
                        ),
                        Icon(Icons.person, color: Colors.black, size: iconSize),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Birthday',
                  style: TextStyle(
                    fontSize: titleFontSize * 1.2,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Container(
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
                        Expanded(
                          child: TextField(
                            controller: _dobController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '---------------',
                              hintStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey, // Light grey color for hint text
                              ),
                            ),
                          ),
                        ),
                        Icon(Icons.calendar_month, color: Colors.black, size: iconSize),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Email',
                  style: TextStyle(
                    fontSize: titleFontSize * 1.2,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Container(
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
                        Expanded(
                          child: TextField(
                            controller: _emailController,
                            enabled: !widget.isGoogleSignIn,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '---------------',
                              hintStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey, // Light grey color for hint text
                              ),
                            ),
                          ),
                        ),
                        Icon(Icons.mail, color: Colors.black, size: iconSize),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Phone',
                  style: TextStyle(
                    fontSize: titleFontSize * 1.2,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Container(
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
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            enabled: widget.isGoogleSignIn,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '---------------',
                              hintStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey, // Light grey color for hint text
                              ),
                            ),
                          ),
                        ),
                        Icon(Icons.phone_in_talk, color: Colors.black, size: iconSize),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Address',
                  style: TextStyle(
                    fontSize: titleFontSize * 1.2,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Container(
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
                        Expanded(
                          child: TextField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '----------------',
                              hintStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey, // Light grey color for hint text
                              ),
                            ),
                          ),
                        ),
                        Icon(Icons.location_on, color: Colors.black, size: iconSize),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Gender',
                  style: TextStyle(
                    fontSize: titleFontSize * 1.2,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Container(
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
                        Expanded(
                          child: DropdownButton<String>(
                            value: _gender,
                            isExpanded: true,
                            onChanged: (String? newValue) {
                              setState(() {
                                _gender = newValue!;
                              });
                            },
                            items: <String>['Male', 'Female', 'Other']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Icon(Icons.person, color: Colors.black, size: iconSize),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _saveUserToDatabase(
                        widget.uid,
                        phone: _phoneController.text,
                        email: _emailController.text,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF35FF3D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      side: BorderSide(width: 3, color: Colors.white), // Thêm viền trắng cho nút
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1,
                        vertical: screenHeight * 0.02,
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: titleFontSize),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
