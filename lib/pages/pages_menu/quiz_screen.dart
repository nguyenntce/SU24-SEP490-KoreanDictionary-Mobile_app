import 'package:flutter/material.dart';
import 'package:myapp/pages/pages_menu/page_quiz/listenandfillword_screen.dart';
import 'package:myapp/pages/pages_menu/page_quiz/pictureandchooseword_screen.dart';
import 'package:myapp/pages/pages_menu/page_quiz/questionandchoosepicture_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<String> types = [];
  List<String> times = [];

  String? selectedType;
  String? selectedTime;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    types = [
      '${AppLocalizations.of(context)!.listen_and_choose_picture}',
      '${AppLocalizations.of(context)!.picture_and_choose_word}',
      '${AppLocalizations.of(context)!.question_and_choose_picture}'
    ];
    times = [
      '${AppLocalizations.of(context)!.five_minute}',
      '${AppLocalizations.of(context)!.ten_minute}',
      '${AppLocalizations.of(context)!.fifteen_minute}'
    ];
  }

  void navigateToSelectedScreen() {
    if (selectedType != null && selectedTime != null) {
      Widget screen;
      int durationInSeconds = selectedTime == '${AppLocalizations.of(context)!.five_minute}'
          ? 5 * 60
          : selectedTime == '${AppLocalizations.of(context)!.ten_minute}'
          ? 10 * 60
          : selectedTime == '${AppLocalizations.of(context)!.fifteen_minute}'
          ? 15 * 60
          : 0;

      if (selectedType == '${AppLocalizations.of(context)!.listen_and_choose_picture}') {
        screen = ListenandfillwordScreen(durationInSeconds);
      } else if (selectedType == '${AppLocalizations.of(context)!.picture_and_choose_word}') {
        screen = PictureandchoosewordScreen(durationInSeconds);
      } else if (selectedType == '${AppLocalizations.of(context)!.question_and_choose_picture}') {
        screen = QuestionandchoosepictureScreen(durationInSeconds);
      } else {
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double titleFontSize = screenWidth * 0.05;

    const double borderWidthRatio = 0.008;
    const double borderRadiusRatio = 0.1;
    const double textPaddingRatio = 0.08;

    double borderWidth = screenWidth * borderWidthRatio;
    double borderRadius = screenWidth * borderRadiusRatio;
    double textPadding = screenWidth * textPaddingRatio;

    return Scaffold(
      backgroundColor: const Color(0xFFA4FFB3),
      appBar: AppBar(
        backgroundColor: Color(0xFF154F41),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.quiz,
          style: TextStyle(
            fontSize: titleFontSize,
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
                  margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.1,
                      vertical: screenHeight * 0.1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: borderWidth),
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: screenHeight * 0.03,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(textPadding),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.quiz_option,
                                  style: TextStyle(
                                    fontSize: titleFontSize * 1.6,
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FontStyle.italic,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(2.0, 2.0),
                                        blurRadius: 2.0,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    AppLocalizations.of(context)!.time,
                                    style: TextStyle(
                                      fontSize: titleFontSize * 0.9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.04),
                                  width: screenWidth * 0.8,
                                  height: screenHeight * 0.06,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(
                                        screenHeight * 0.03),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                    ),
                                    hint: Text("${AppLocalizations.of(context)!.select_time}"),
                                    value: selectedTime,
                                    isExpanded: true,
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedTime = newValue;
                                      });
                                    },
                                    items: times.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    AppLocalizations.of(context)!.type,
                                    style: TextStyle(
                                      fontSize: titleFontSize * 0.9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.04),
                                  width: screenWidth * 0.8,
                                  height: screenHeight * 0.06,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(
                                        screenHeight * 0.03),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                    ),
                                    hint: Text("${AppLocalizations.of(context)!.select_type}"),
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
                                SizedBox(height: screenHeight * 0.03),
                                ElevatedButton(
                                  onPressed: () {
                                    navigateToSelectedScreen();
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.start_quiz,
                                    style: TextStyle(
                                        fontSize: titleFontSize * 0.9,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF35FF3D),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenHeight * 0.05,
                                        vertical: screenWidth * 0.03),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(borderRadius),
                                      side: BorderSide(
                                          color: Colors.black, width: 1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
