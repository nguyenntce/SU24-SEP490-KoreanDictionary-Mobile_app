import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
class DetailresultQuizScreen extends StatefulWidget {
  final List<Map<String, dynamic>> results;

  const DetailresultQuizScreen({Key? key, required this.results}) : super(key: key);

  @override
  State<DetailresultQuizScreen> createState() => _DetailresultQuizScreenState();
}

class _DetailresultQuizScreenState extends State<DetailresultQuizScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleFontSize = screenWidth * 0.05;

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
          'Detailed Results',
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
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            height: screenHeight * 0.1, // Fixed height for the header
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'English',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Korean',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Answer',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.results.length,
            itemBuilder: (context, index) {
              final result = widget.results[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.01,
                  horizontal: screenHeight * 0.01,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.03,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.localeName == 'en'
                                ? result['english'] ?? ''
                                : AppLocalizations.of(context)!.localeName == 'ko'
                                ? result['korean'] ?? ''
                                : result['vietnamese'] ?? '',
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.05,
                        height: screenHeight * 0.15,
                      ),
                      Expanded(
                        child: Container(
                          height: screenHeight * 0.13,
                          color: Colors.transparent,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                bottom: screenHeight * 0.028,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(screenHeight * 0.00),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Image.network(
                                    result['image'] ?? '',
                                    width: screenWidth * 0.1,
                                    height: screenHeight * 0.1,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Play the corresponding audio
                                },
                                child: Positioned(
                                  child: Container(
                                    height: screenHeight * 0.025,
                                    margin: EdgeInsets.only(
                                      left: screenWidth * 0.02,
                                      right: screenWidth * 0.02,
                                      top: screenHeight * 0.105,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF35FF3D),
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.volume_up,
                                          size: screenWidth * 0.04,
                                          color: Colors.black,
                                        ),
                                        Expanded(
                                          child: Text(
                                            result['korean'] ?? '',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.025,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.black,
                                              fontStyle: FontStyle.italic,
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
                      SizedBox(width: screenWidth * 0.02),
                      Expanded(
                        child: Container(
                          height: screenHeight * 0.13,
                          color: Colors.transparent,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                bottom: screenHeight * 0.028,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(screenHeight * 0.00),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Image.network(
                                    result['answer'] ?? '',
                                    width: screenWidth * 0.1,
                                    height: screenHeight * 0.1,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: screenHeight * 0.0040,
                                left: screenHeight * 0.01,
                                right: screenHeight * 0.01,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.localeName == 'en'
                                        ? result['answerEN'] ?? ''
                                        : AppLocalizations.of(context)!.localeName == 'ko'
                                        ? result['answerKR'] ?? ''
                                        : result['answerVN'] ?? '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.025,
                                      fontWeight: FontWeight.w900,
                                      color: result['isCorrect'] ? Colors.green : Colors.red,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
