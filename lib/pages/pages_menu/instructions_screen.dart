// instructions_screen.dart
import 'package:flutter/material.dart';

class InstructionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleFontSize = screenWidth * 0.05;
    double imageSize = screenWidth * 0.3; // Kích thước của hình ảnh
    double imageContainerHeight =
        screenHeight * 0.25; // Chiều cao của container chứa hình ảnh
    double containerHeight =
        screenHeight * 0.08; // Chiều cao của container chứa TextField

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
          'Instructions',
          style: TextStyle(
            fontSize: titleFontSize * 1.5,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.0),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: imageContainerHeight * 0.4,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child:
                              Container(), // Container trống để căn giữa hình ảnh
                        ),
                        Container(
                          width: imageSize * 0.6,
                          // Tăng kích thước của icon lên
                          height: imageSize * 0.6,
                          // Tăng kích thước của icon lên

                          child: Icon(
                            Icons.lightbulb_outline, // Icon bạn muốn sử dụng
                            size: imageSize * 0.5, // Kích thước của icon
                            color: Colors.black, // Màu của icon
                          ),
                          padding: EdgeInsets.all(
                              4.0), // Tạo viền bằng cách thêm padding
                        ),
                        Expanded(
                          child:
                              Container(), // Container trống để căn giữa hình ảnh
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Container(
                    alignment: Alignment.center, // Đảm bảo alignment này
                    child: Text(
                      'Tips For Taking Pictures',
                      style: TextStyle(
                        fontSize: titleFontSize * 1.2,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    'Place your object in the center of frame, avoid dark or blury images',
                    style: TextStyle(
                      fontSize: titleFontSize * 0.8,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Image.asset(
                          'assets/fail_image1.png',
                          // Đường dẫn của hình ảnh không nền
                          fit: BoxFit.contain,
                          color: Colors.transparent,
                          // Đặt màu của hình ảnh thành màu trong suốt
                          colorBlendMode: BlendMode.color,
                          // Loại bỏ màu nền
                          width: screenWidth * 0.35,
                          // Đặt chiều rộng của hình ảnh
                          height: containerHeight *
                              1.5, // Đặt chiều cao của hình ảnh
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Image.asset(
                          'assets/correct_image1.png',
                          // Đường dẫn của hình ảnh không nền
                          fit: BoxFit.contain,
                          color: Colors.transparent,
                          // Đặt màu của hình ảnh thành màu trong suốt
                          colorBlendMode: BlendMode.color,
                          // Loại bỏ màu nền
                          width: screenWidth * 0.35,
                          // Đặt chiều rộng của hình ảnh
                          height: containerHeight *
                              1.5, // Đặt chiều cao của hình ảnh
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    'If the object is too big for the frame, only take a picture of its fruits',
                    style: TextStyle(
                      fontSize: titleFontSize * 0.8,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Image.asset(
                          'assets/fail_image2.png',
                          // Đường dẫn của hình ảnh không nền
                          fit: BoxFit.contain,
                          color: Colors.transparent,
                          // Đặt màu của hình ảnh thành màu trong suốt
                          colorBlendMode: BlendMode.color,
                          // Loại bỏ màu nền
                          width: screenWidth * 0.35,
                          // Đặt chiều rộng của hình ảnh
                          height: containerHeight *
                              1.5, // Đặt chiều cao của hình ảnh
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Image.asset(
                          'assets/correct_image2.png',
                          // Đường dẫn của hình ảnh không nền
                          fit: BoxFit.contain,
                          color: Colors.transparent,
                          // Đặt màu của hình ảnh thành màu trong suốt
                          colorBlendMode: BlendMode.color,
                          // Loại bỏ màu nền
                          width: screenWidth * 0.35,
                          // Đặt chiều rộng của hình ảnh
                          height: containerHeight *
                              1.5, // Đặt chiều cao của hình ảnh
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    'Do not bring your smart phone too close, just make sure that the fruits is clear and in the frame',
                    style: TextStyle(
                      fontSize: titleFontSize * 0.8,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Image.asset(
                          'assets/fail_image3.png',
                          // Đường dẫn của hình ảnh không nền
                          fit: BoxFit.contain,
                          color: Colors.transparent,
                          // Đặt màu của hình ảnh thành màu trong suốt
                          colorBlendMode: BlendMode.color,
                          // Loại bỏ màu nền
                          width: screenWidth * 0.35,
                          // Đặt chiều rộng của hình ảnh
                          height: containerHeight *
                              1.5, // Đặt chiều cao của hình ảnh
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Image.asset(
                          'assets/correct_image3.png',
                          // Đường dẫn của hình ảnh không nền
                          fit: BoxFit.contain,
                          color: Colors.transparent,
                          // Đặt màu của hình ảnh thành màu trong suốt
                          colorBlendMode: BlendMode.color,
                          // Loại bỏ màu nền
                          width: screenWidth * 0.35,
                          // Đặt chiều rộng của hình ảnh
                          height: containerHeight *
                              1.5, // Đặt chiều cao của hình ảnh
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    'Only include one type of fruit',
                    style: TextStyle(
                      fontSize: titleFontSize * 0.8,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Image.asset(
                          'assets/fail_image4.png',
                          // Đường dẫn của hình ảnh không nền
                          fit: BoxFit.contain,
                          color: Colors.transparent,
                          // Đặt màu của hình ảnh thành màu trong suốt
                          colorBlendMode: BlendMode.color,
                          // Loại bỏ màu nền
                          width: screenWidth * 0.35,
                          // Đặt chiều rộng của hình ảnh
                          height: containerHeight *
                              1.5, // Đặt chiều cao của hình ảnh
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Image.asset(
                          'assets/correct_image4.png',
                          // Đường dẫn của hình ảnh không nền
                          fit: BoxFit.contain,
                          color: Colors.transparent,
                          // Đặt màu của hình ảnh thành màu trong suốt
                          colorBlendMode: BlendMode.color,
                          // Loại bỏ màu nền
                          width: screenWidth * 0.35,
                          // Đặt chiều rộng của hình ảnh
                          height: containerHeight *
                              1.5, // Đặt chiều cao của hình ảnh
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.1),
                ], // Thêm dấu ngoặc cho mảng children của Column
              ), // Thêm dấu ngoặc cho Padding
            ), // Thêm dấu ngoặc cho Padding
          ], // Thêm dấu ngoặc cho mảng children của ListView
        ), // Thêm dấu ngoặc cho Padding
      ), // Thêm dấu ngoặc cho body
    ); // Thêm dấu ngoặc cho Scaffold
  }
} // Thêm dấu ngoặc cho class InstructionsScreen
