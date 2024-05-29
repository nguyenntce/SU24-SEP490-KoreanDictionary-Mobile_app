import 'package:flutter/material.dart';

class DetailresultQuizScreen extends StatefulWidget {
  const DetailresultQuizScreen({super.key});

  @override
  State<DetailresultQuizScreen> createState() => _DetailresultQuizScreenState();
}

class _DetailresultQuizScreenState extends State<DetailresultQuizScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleFontSize = screenWidth * 0.05;
    double imageContainerHeight = screenHeight * 0.1;

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
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              height: imageContainerHeight,
              width: double.infinity,
              child: Row(
                children: [
                  SizedBox(width: screenWidth * 0.05),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
