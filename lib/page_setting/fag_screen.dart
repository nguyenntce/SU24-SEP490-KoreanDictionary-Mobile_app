import 'package:flutter/material.dart';

class FaqScreen extends StatefulWidget {
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  bool _isExpanded1 = false;
  bool _isExpanded2 = false;
  bool _isExpanded3 = false;
  bool _isExpanded4 = false;
  bool _isExpanded5 = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleFontSize = screenWidth * 0.05;
    double containerPadding = screenWidth * 0.04;
    double containerBorderRadius = screenWidth * 0.04;
    double borderWidth = screenWidth * 0.005;
    double questionFontSize = screenWidth * 0.045;
    double answerFontSize = screenWidth * 0.04;

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
          'TAO AN CUT',
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(containerPadding),
        child: ListView(
          children: <Widget>[
            _buildExpansionPanel(
              'How do I get more accurate recognition results?',
              'To get more accurate recognition results in the "Korean Fruit Technology" app, ensure you use high-quality images with good lighting, follow any provided guidelines for taking or uploading images, keep the app updated to benefit from the latest improvements, and check your app settings to make sure they are optimized for the best results.',
              _isExpanded1,
                  (bool isExpanded) {
                setState(() {
                  _isExpanded1 = !_isExpanded1;
                });
              },
              containerBorderRadius,
              borderWidth,
              questionFontSize,
              answerFontSize,
            ),
            SizedBox(height: screenHeight * 0.02),
            _buildExpansionPanel(
              'How to send feedback?',
              'To send feedback on the "Korean Fruit Technology" app, open the app, go to the "Feedback" section in the menu or settings, fill out the form, and submit it',
              _isExpanded2,
                  (bool isExpanded) {
                setState(() {
                  _isExpanded2 = !_isExpanded2;
                });
              },
              containerBorderRadius,
              borderWidth,
              questionFontSize,
              answerFontSize,
            ),
            SizedBox(height: screenHeight * 0.02),
            _buildExpansionPanel(
              'How to contact you?',
              'You need to go to “Setting”, select “About Us”, then you will see full information about us. There are two ways to contact me directly, including Facebook and Email.',
              _isExpanded3,
                  (bool isExpanded) {
                setState(() {
                  _isExpanded3 = !_isExpanded3;
                });
              },
              containerBorderRadius,
              borderWidth,
              questionFontSize,
              answerFontSize,
            ),
            SizedBox(height: screenHeight * 0.02),
            _buildExpansionPanel(
              'What app can I use to recognize objects in images from my photo collection?',
              'When required to take the first photo, click on the photo library icon next to the camera.Now you can download photos from the photo library on your phone to the application.Position and time of shooting will be read from photos and saved in observation',
              _isExpanded4,
                  (bool isExpanded) {
                setState(() {
                  _isExpanded4 = !_isExpanded4;
                });
              },
              containerBorderRadius,
              borderWidth,
              questionFontSize,
              answerFontSize,
            ),
            SizedBox(height: screenHeight * 0.02),
            _buildExpansionPanel(
              'How the application works?',
              'With your smartphone camera, you take a photo of the fruit or fruit and within seconds you will receive a suggestion about the name of the fruit or fruit as well as further information. Therefore, this app allows easy and safe fruit identification for people of all ages and all levels of previous knowledge. More information and screenshots can be found on our site',
              _isExpanded5,
                  (bool isExpanded) {
                setState(() {
                  _isExpanded5 = !_isExpanded5;
                });
              },
              containerBorderRadius,
              borderWidth,
              questionFontSize,
              answerFontSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionPanel(
      String question,
      String answer,
      bool isExpanded,
      void Function(bool) expansionCallback,
      double borderRadius,
      double borderWidth,
      double questionFontSize,
      double answerFontSize,
      ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.black, width: borderWidth),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: ExpansionPanelList(
          elevation: 1,
          expansionCallback: (int index, bool isExpanded) {
            expansionCallback(isExpanded);
          },
          children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(
                    question,
                    style: TextStyle(
                      fontSize: questionFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
              body: ListTile(
                title: Text(
                  answer,
                  style: TextStyle(
                    fontSize: answerFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              isExpanded: isExpanded,
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FaqScreen(),
  ));
}
