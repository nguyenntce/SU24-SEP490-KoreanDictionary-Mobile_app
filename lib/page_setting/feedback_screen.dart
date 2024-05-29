import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  List<String> types = ['Vocabulary', 'Application', 'Other'];
  String? selectedType;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleFontSize = screenWidth * 0.05;
    double iconSize = screenWidth * 0.1;

    const double containerMarginRatio = 0.04;
    const double borderWidthRatio = 0.005;
    const double borderRadiusRatio = 0.1;
    const double textPaddingRatio = 0.075;
    const double iconTopPositionRatio = 0.75;
    const double textBottomPositionRatio = 0.2;

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
          'Feedback',
          style: TextStyle(
            fontSize: titleFontSize * 1.5,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: true,
                child: Container(
                  margin: EdgeInsets.all(screenWidth * containerMarginRatio),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.black,
                        width: screenWidth * borderWidthRatio),
                    borderRadius:
                        BorderRadius.circular(screenWidth * borderRadiusRatio),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: screenHeight * textBottomPositionRatio / 3,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Padding(
                            padding:
                                EdgeInsets.all(screenWidth * textPaddingRatio),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Give App Feedback',
                                  style: TextStyle(
                                    fontSize: titleFontSize * 1.3,
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: screenWidth * 0.02),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Email Address',
                                      style: TextStyle(
                                        fontSize: titleFontSize * 0.9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.02),
                                    // Add some space between the texts
                                  ],
                                ),
                                Container(
                                  width: screenWidth * 0.8,
                                  // Set the width of the container
                                  height: screenHeight * 0.06,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 0.06),
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'abc@gmail.com',
                                      // Display hint text
                                      border: InputBorder.none,
                                      // Remove default border of TextField
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: screenWidth *
                                              0.03), // Padding inside TextField
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenWidth * 0.02),
                                // Add some space between the texts
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Type',
                                      style: TextStyle(
                                        fontSize: titleFontSize * 0.9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.02),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.04),
                                  width: screenWidth * 0.8,
                                  // Set the width of the container
                                  height: screenHeight * 0.06,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(
                                        screenHeight * 0.06),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    hint: Text("Select Type"),
                                    value: selectedType,
                                    isExpanded: true,
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedType = newValue;
                                      });
                                    },
                                    items: types.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(height: screenWidth * 0.02),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Description',
                                      style: TextStyle(
                                        fontSize: titleFontSize * 0.9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenWidth * 0.02),
                                Container(
                                  width: screenWidth * 0.8,
                                  // Set the width of the container
                                  height: screenHeight * 0.06,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 0.06),
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Your description...',
                                      // Display hint text
                                      border: InputBorder.none,
                                      // Remove default border of TextField
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: screenWidth *
                                              0.03), // Padding inside TextField
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenWidth * 0.02),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: screenHeight * iconTopPositionRatio * 1.1,
                        child: Center(
                          child: Icon(
                            Icons.feedback,
                            size: iconSize * 2,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
