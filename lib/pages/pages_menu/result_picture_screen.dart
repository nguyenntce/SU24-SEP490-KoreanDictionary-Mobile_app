import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ResultPictureScreen extends StatefulWidget {
  final String imagePath;
  const ResultPictureScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  _ResultPictureScreenState createState() => _ResultPictureScreenState();
}

class _ResultPictureScreenState extends State<ResultPictureScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.reference().child('Vocabulary');
  int? targetId;
  Map<String, dynamic>? vocabularyData;
  bool isLoading = true;
  String? errorMessage;
  final AudioPlayer audioPlayer = AudioPlayer();
  void _playAudio(String url) async {
    try {
      await audioPlayer.play(UrlSource(url)); // Sử dụng UrlSource cho URL

    } catch (e) {
      print('Error: $e');
      print(url);
    }
  }
  Future<void> _sendImageToServer() async {
    var request = http.MultipartRequest('POST',
        Uri.parse('https://d55d5b2a-e20e-46ef-a1f3-aec0f317de0b-00-2wojbvrhlnbue.pike.replit.dev/predict'));
    request.files.add(await http.MultipartFile.fromPath('image', widget.imagePath));
    print('goi dc api ');

    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(responseData) as List;
      if (jsonResponse.isNotEmpty) {
        // Kiểm tra và chuyển đổi kiểu dữ liệu cho jsonId
        dynamic jsonIdDynamic = jsonResponse[0]['id'];
        int jsonId;
        if (jsonIdDynamic is double) {
          jsonId = jsonIdDynamic.toInt();
        } else if (jsonIdDynamic is int) {
          jsonId = jsonIdDynamic;
        } else {
          throw Exception("Unexpected type for jsonId: ${jsonIdDynamic.runtimeType}");
        }

        targetId = jsonId + 1;
        print('Target ID: $targetId'); // In ra targetId để kiểm tra
        _fetchVocabulary();
      }
    } else {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to upload image. Status Code: ${response.statusCode}';
      });
    }
  }

  void _fetchVocabulary() async {
    try {
      Query query = _database.orderByChild('Id').equalTo(targetId);
      DataSnapshot snapshot = await query.get();

      if (snapshot.exists) {

        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          if (value != null && value['Id'] == targetId) {
            setState(() {
              vocabularyData = Map<String, dynamic>.from(value);
              isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'No matching item found';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _sendImageToServer();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleFontSize = screenWidth * 0.05;
    double imageSize = screenWidth * 0.3;
    double imageContainerHeight = screenHeight * 0.25;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF154F41),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.result,
          style: TextStyle(
            fontSize: titleFontSize * 1.5,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  heightFactor: 0.3, // Hiển thị phần giữa tấm hình
                  child: Image.file(
                    File(widget.imagePath),
                    fit: BoxFit.cover,
                    width: screenWidth,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Center(
              child: Text(
                '${vocabularyData!['Korean']}',
                style: TextStyle(
                  fontSize: titleFontSize * 1.5,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(2, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/${AppLocalizations.of(context)!.localeName == 'en' ? 'english_flag.png' : AppLocalizations.of(context)!.localeName == 'ko' ? 'korean_flag.png' : 'vietnam_flag.png'}',
                          width: screenWidth * 0.2,
                        ),
                        Container(
                          width: screenWidth * 0.6,
                          child: Row(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${AppLocalizations.of(context)!.localeName == 'en' ? vocabularyData!['English'] : AppLocalizations.of(context)!.localeName == 'ko' ? vocabularyData!['Korean'] : vocabularyData!['Vietnamese']}',
                                    style: TextStyle(
                                      fontSize: titleFontSize * 0.9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                alignment: Alignment.centerRight,
                                icon: Icon(
                                  Icons.volume_up,
                                  color: Colors.black,
                                  size: screenWidth * 0.1,
                                ),
                                onPressed: () {
                                  _playAudio(AppLocalizations.of(context)!.localeName == 'en' ? vocabularyData!['Voice_EN']!
                                      : AppLocalizations.of(context)!.localeName == 'ko' ? vocabularyData!['Voice_KR']! :
                                  vocabularyData!['Voice_VN']!);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    if(AppLocalizations.of(context)!.localeName != 'ko')
                    Row(
                      children: [
                        Image.asset(
                          'assets/korean_flag.png',
                          width: screenWidth * 0.2,
                        ),
                        Container(
                          width: screenWidth * 0.6,
                          child: Row(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${vocabularyData!['Korean']}',
                                    style: TextStyle(
                                      fontSize: titleFontSize * 0.9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                alignment: Alignment.centerRight,
                                icon: Icon(
                                  Icons.volume_up,
                                  color: Colors.black,
                                  size: screenWidth * 0.1,
                                ),
                                onPressed: () {
                                  _playAudio(vocabularyData!['Voice_KR']);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                '${AppLocalizations.of(context)!.localeName == 'en' ? vocabularyData!['Example_EN'] :
                AppLocalizations.of(context)!.localeName == 'ko' ? vocabularyData!['Example_KR'] : vocabularyData!['Example_VN']}',
                style: TextStyle(fontSize: titleFontSize * 1),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            if(AppLocalizations.of(context)!.localeName != 'ko')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                '${vocabularyData!['Example_KR']}',
                style: TextStyle(fontSize: titleFontSize * 1),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              '${AppLocalizations.of(context)!.imageof} ${AppLocalizations.of(context)!.localeName == 'en' ? vocabularyData!['English'] :
              AppLocalizations.of(context)!.localeName == 'ko' ? vocabularyData!['Korean'] : vocabularyData!['Vietnamese']}',
              style: TextStyle(
                fontSize: titleFontSize * 0.8,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              height: imageContainerHeight,
              child: Column(
                children: [Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(screenHeight *
                          0.03), // Điều chỉnh padding theo nhu cầu của bạn
                      child: Container(
                        width: imageSize * 1.5,
                        height: imageSize * 1,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius:
                          BorderRadius.circular(imageSize * 0.1),
                        ),
                        child: Image.network(
                          vocabularyData!["Fruits_img"],
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  ],
                ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
