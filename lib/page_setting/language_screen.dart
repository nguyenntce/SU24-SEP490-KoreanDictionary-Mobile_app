import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';

import '../provider/locale_provider.dart';
class LanguageScreen extends StatelessWidget {
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
          AppLocalizations.of(context)!.language,
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
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            languageContainer(context, screenWidth, screenHeight, titleFontSize,
                'assets/vietnam_flag.png', AppLocalizations.of(context)!.vietnam, Locale('vi')),
            languageContainer(context, screenWidth, screenHeight, titleFontSize,
                'assets/english_flag.png', AppLocalizations.of(context)!.english, Locale('en')),
            languageContainer(context, screenWidth, screenHeight, titleFontSize,
                'assets/korean_flag.png', AppLocalizations.of(context)!.korean, Locale('ko')),
          ],
        ),
      ),
    );
  }

  Widget languageContainer(
      BuildContext context,
      double screenWidth,
      double screenHeight,
      double titleFontSize,
      String imagePath,
      String languageName,
      Locale locale) {
    return GestureDetector(
      onTap: () {
        Provider.of<LocaleProvider>(context, listen: false).setLocale(locale);
      },
      child: Container(
        width: screenWidth,
        height: screenHeight * 0.1,
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(60),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: screenHeight * 0.08,
              height: screenHeight * 0.08,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            Text(
              languageName,
              style: TextStyle(
                fontSize: titleFontSize * 1.2,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
