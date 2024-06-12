import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
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
          AppLocalizations.of(context)!.frequentlyaskedquestion,
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
              AppLocalizations.of(context)!.howdoigetmoreaccuraterecognitionresult,
              AppLocalizations.of(context)!.descrip_howdoiget,
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
              AppLocalizations.of(context)!.howtoisendfeedback,
              AppLocalizations.of(context)!.descrip_howtosendfeedback,
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
              AppLocalizations.of(context)!.howtocontactyou,
              AppLocalizations.of(context)!.descrip_howtocontactyou,
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
              AppLocalizations.of(context)!.whatappican,
              AppLocalizations.of(context)!.descrip_whatapp,
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
              AppLocalizations.of(context)!.howtheapplicationworks,
              AppLocalizations.of(context)!.descrip_howtheapplicationwork,
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
