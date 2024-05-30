import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
              height: imageContainerHeight * 1.8,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(), // Container trống để căn giữa hình ảnh
                  ),
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
                    padding:
                        EdgeInsets.all(4.0), // Tạo viền bằng cách thêm padding
                  ),
                  Expanded(
                    child: Container(), // Container trống để căn giữa hình ảnh
                  ),
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
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Truong Duy Khang',
                              hintStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Icon(Icons.person, color: Colors.black, size: iconSize),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01), // Thêm khoảng cách
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
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '---------------',
                              hintStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.calendar_month,
                          color: Colors.black,
                          size: iconSize,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01), // Thêm khoảng cách
                Text(
                  'Job',
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
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '---------------',
                              hintStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.work,
                          color: Colors.black,
                          size: iconSize,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01), // Thêm khoảng cách
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
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '---------------',
                              hintStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.mail,
                          color: Colors.black,
                          size: iconSize,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01), // Thêm khoảng cách
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
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '---------------',
                              hintStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.phone_in_talk,
                          color: Colors.black,
                          size: iconSize,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01), // Thêm khoảng cách
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
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '----------------',
                              hintStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.location_on,
                          color: Colors.black,
                          size: iconSize,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03), // Thêm khoảng cách
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Code xử lý khi nhấn nút Save
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF35FF3D),
                      // Đặt màu xanh lá cho nút
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      side: BorderSide(
                          width: 3,
                          color: Colors.white), // Thêm viền trắng cho nút
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
