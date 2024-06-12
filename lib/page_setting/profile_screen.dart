import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:country_picker/country_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

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
  File? _image;
  String _avatarUrl = '';

  final DatabaseReference _database = FirebaseDatabase.instance.reference().child('Account');
  final ImagePicker _picker = ImagePicker();

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
      String countryCode = userData['CountryCode'] ?? '84';
      _phoneController.text = userData['Phone']?.toString().replaceFirst(countryCode, '0') ?? '';
      _addressController.text = userData['Country'] ?? '';
      _gender = ['Male', 'Female'].contains(userData['Gender']) ? userData['Gender'] : 'Male';
      _avatarUrl = userData['Avatar'] ?? '';
    });
  }

  Future<void> _saveUserToDatabase(String uid, {String? phone, String? email, String countryCode = '84'}) async {
    if (!_validateEmail(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a valid email address',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Color(0xFF35FF3D), width: 2),
          ),
        ),
      );
      return;
    }
    if (!_validatePhoneNumber(_phoneController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a valid phone number',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Color(0xFF35FF3D), width: 2),
          ),
        ),
      );
      return;
    }
    try {
      String imageUrl = _avatarUrl;
      if (_image != null) {
        imageUrl = await _uploadImageToFirebase(uid);
      }

      final formattedPhone = phone?.replaceFirst('0', countryCode);
      await _database.child(uid).update({
        "Avatar": imageUrl, // Cập nhật URL của ảnh đại diện
        "Country": _addressController.text,
        "Dob": _dobController.text,
        "Email": email ?? _emailController.text,
        "Fullname": _fullnameController.text,
        "Gender": _gender,
        "Phone": formattedPhone ?? _phoneController.text.replaceFirst('0', countryCode),
        "Status": 1,
      });
      setState(() {
        _avatarUrl = imageUrl;
      });
      print('You have saved successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You have saved successfully',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent, // Transparent background color
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            // side: BorderSide(color: Color(0xFF35FF3D), width: 2),
          ),
        ),
      );
    } catch (e) {
      print('You have saved Failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You have saved Failed: $e',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent, // Transparent background color
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            // side: BorderSide(color: Color(0xFF35FF3D), width: 1),
          ),
        ),
      );
    }
  }

  Future<String> _uploadImageToFirebase(String uid) async {
    final storageReference = FirebaseStorage.instance.ref().child('avatars/$uid.jpg');
    final uploadTask = storageReference.putFile(_image!);
    final snapshot = await uploadTask;
    final imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }

  bool _validatePhoneNumber(String phoneNumber) {
    String pattern = r'^\+?[0-9]{10,15}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(phoneNumber);
  }

  bool _validateEmail(String email) {
    String pattern =
        r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime.now(), // Set the last date to the current date
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _selectCountry(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: false, // Optional. Shows phone code before the country name.
      onSelect: (Country country) {
        setState(() {
          _addressController.text = country.name;
        });
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
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
                  Stack(
                    children: [
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
                            image: _image != null
                                ? FileImage(_image!)
                                : (_avatarUrl.isNotEmpty
                                ? NetworkImage(_avatarUrl)
                                : AssetImage('assets/avatarprofile.png')) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        padding: EdgeInsets.all(4.0), // Tạo viền bằng cách thêm padding
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 44, // Tăng kích thước của ô tròn để thêm padding
                          height: 44, // Tăng kích thước của ô tròn để thêm padding
                          padding: EdgeInsets.all(2), // Thêm padding để tạo viền trắng
                          decoration: BoxDecoration(
                            color: Colors.white, // Màu nền của ô tròn
                            shape: BoxShape.circle, // Hình dạng tròn
                            border: Border.all(
                              color: Colors.blue, // Màu viền
                              width: 2, // Độ dày của viền
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.camera_alt_outlined, color: Colors.blue),
                            onPressed: _pickImage,
                            iconSize: 20, // Kích thước của icon
                          ),
                        ),
                      ),

                    ],
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
                            enabled: false,
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
                        IconButton(
                          icon: Icon(Icons.calendar_month, color: Colors.black, size: iconSize),
                          onPressed: () => _selectDate(context),
                        ),
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
                              // errorText: _validatePhoneNumber(_phoneController.text) ? null : 'Invalid phone number',
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
                  'Country',
                  style: TextStyle(
                    fontSize: titleFontSize * 1.2,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                GestureDetector(
                  onTap: () => _selectCountry(context),
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
                          Expanded(
                            child: TextField(
                              controller: _addressController,
                              enabled: false,
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
                            items: <String>['Male', 'Female']
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