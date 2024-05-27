import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String imagePath;
  final String label;
  final Widget destinationScreen;

  MenuItem({
    required this.imagePath,
    required this.label,
    required this.destinationScreen,
  });

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình
    final screenWidth = MediaQuery.of(context).size.width;

    // Tính toán kích thước cho hình ảnh
    final imageWidth = screenWidth * 0.2; // 25% chiều rộng màn hình
    final imageHeight = imageWidth * 0.9; // Chiều cao dựa trên tỷ lệ 4:5

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen),
        );
      },
      child: Column(
        children: [
          Image.asset(
            imagePath,
            width: imageWidth,
            height: imageHeight,
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              // Kích thước văn bản là 4% chiều rộng màn hình
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
