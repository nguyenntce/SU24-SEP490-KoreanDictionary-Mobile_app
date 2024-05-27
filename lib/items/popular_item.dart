import 'package:flutter/material.dart';

class PopularItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình
    final screenWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: Container(
        height: screenWidth * 0.2, // Chiều cao là 20% chiều rộng màn hình
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02), // Lề 2% chiều rộng màn hình
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(screenWidth * 0.05), // Bo tròn 5% chiều rộng màn hình
          border: Border.all(color: Colors.black, width: screenWidth * 0.01), // Viền dày 1% chiều rộng màn hình
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              spreadRadius: screenWidth * 0.01, // Bán kính lớn 1% chiều rộng màn hình
              blurRadius: screenWidth * 0.02, // Độ mờ 2% chiều rộng màn hình
              offset: Offset(0, screenWidth * 0.015), // Độ dịch là 1.5% chiều rộng màn hình
            ),
          ],
        ),
      ),
    );
  }
}
