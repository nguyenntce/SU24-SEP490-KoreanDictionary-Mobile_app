import 'package:flutter/material.dart';
import 'package:myapp/items/corner_camera_item.dart';
import 'package:myapp/pages/home_screen.dart';
import 'package:myapp/pages/pages_menu/instructions_screen.dart';

class CameraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double iconSize = screenWidth * 0.1;

    // Tính toán padding và kích thước dựa trên kích thước màn hình
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: iconSize * 1),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Xử lý sự kiện cho icon 1
            },
            icon: Icon(Icons.flash_on, color: Colors.white, size: iconSize * 1),
          ),
          IconButton(
            onPressed: () {
              // Xử lý sự kiện cho icon 2
            },
            icon: Icon(Icons.camera_alt_outlined,
                color: Colors.white, size: iconSize * 1),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.1),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.55,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.1),
                  // Padding giữa trên và dưới
                  child: CustomPaint(
                    painter: CornerDashedBorderPainterCamera(),
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      // Điều chỉnh khoảng cách giữa hình ảnh và đường viền
                      child: Image.asset(
                        'assets/duahau.png',
                        // Đường dẫn tới hình ảnh của quả dưa hấu
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Thêm footer là hình ảnh
          Container(
            width: double.infinity,
            child: Stack(
              children: [
                Image.asset(
                  'assets/footer_home.png',
                  width: screenWidth,
                  // Thay đường dẫn tới hình ảnh footer
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: screenHeight * 0.015,
                  right: screenWidth * 0.7,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: Icon(
                      Icons.photo_library,
                      size: screenWidth * 0.15,
                      // Kích thước icon dựa trên chiều rộng màn hình
                      color: Colors.white, // Màu của icon
                    ),
                  ),
                ),
                Positioned(
                  bottom: screenHeight * 0.01,
                  left: screenWidth * 0.48 - (screenWidth * 0.15 / 2),
                  // Đặt vị trí ngang cho hình ảnh camera
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => HomeScreen()));
                    },
                    child: Icon(
                      Icons.radio_button_checked,
                      size: screenWidth * 0.20,
                      // Kích thước icon dựa trên chiều rộng màn hình
                      color: Colors.white, // Màu của icon
                    ),
                  ),
                ),
                Positioned(
                  bottom: screenHeight * 0.015,
                  left: screenWidth * 0.7,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InstructionsScreen()));
                    },
                    child: Icon(
                      Icons.question_mark,
                      size: screenWidth * 0.15,
                      // Kích thước icon dựa trên chiều rộng màn hình
                      color: Colors.white, // Màu của icon
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
