import 'dart:io';

import 'package:firebase_database/firebase_database.dart'; // Import Firebase Realtime Database
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myapp/page_setting/setting_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int accountId = 0;
  List<String> types = [];
  List<String> typeKeys = ['Vocabulary', 'Take Picture', 'Quiz', 'Flashcard', 'Other'];
  String? selectedType;
  File? image;
  bool isImageSelected = false;
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initUserId();

  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    types = ['${AppLocalizations.of(context)!.vocabulary}', '${AppLocalizations.of(context)!.takepicture}', '${AppLocalizations.of(context)!.quiz}',
      '${AppLocalizations.of(context)!.flashcard}', '${AppLocalizations.of(context)!.other}'];
  }
  Future<void> _initUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accountId = prefs.getInt('UID') ?? 0;
  }

  Future<void> _pickImage(int boxNumber) async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
        isImageSelected = true;
      });
    }
  }

  Future<void> _uploadFeedback() async {
    if (selectedType == null || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a type and enter a description',
            style: TextStyle(color: Colors.black),
          ),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.greenAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Color(0xFF35FF3D), width: 2),
          ),
        ),
      );
      return;
    }
    DateTime created_date = DateTime.now();
    String created_date_str = DateFormat('dd-MM-yyyy').format(created_date);
    String imageUrl = '';
    if (image != null) {
      final storageRef = FirebaseStorage.instance.ref().child('feedback_images/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(image!);
      final snapshot = await uploadTask.whenComplete(() => {});
      imageUrl = await snapshot.ref.getDownloadURL();
    }
    DatabaseReference feedbackRef = FirebaseDatabase.instance.reference().child('General Feedback');
    String feedbackId = feedbackRef.push().key ?? '';
    int selectedIndex = types.indexOf(selectedType ?? '');
    String typeToSave = selectedIndex != -1 ? typeKeys[selectedIndex] : '';
    final feedbackData = {
      'Id': feedbackId,
      'Account_Id': accountId,
      'Created_date': created_date_str,
      'Description': descriptionController.text,
      'Image': imageUrl,
      'Status': 1,
      'Type': typeToSave,
    };


    await feedbackRef.child(feedbackId).set(feedbackData);
    // Hiển thị thông báo thành công
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${AppLocalizations.of(context)!.feedbacksent}'),
        duration: Duration(seconds: 1), // Duration for how long the SnackBar will be displayed
      ),
    );

    await Future.delayed(Duration(seconds: 1));
    Navigator.of(context).pop();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleFontSize = screenWidth * 0.05;
    double iconSize = screenWidth * 0.1;

    return Scaffold(
      backgroundColor: const Color(0xFFA4FFB3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF154F41),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.feedback,
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
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: screenHeight * 0.03,
                      vertical: screenHeight * 0.01),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.black, width: screenWidth * 0.005),
                    borderRadius: BorderRadius.circular(screenWidth * 0.1),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.question_answer_outlined,
                          size: iconSize * 2,
                          color: Colors.black,
                        ),
                        Text(
                          AppLocalizations.of(context)!.give_app_feedback,
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
                              AppLocalizations.of(context)!.type,
                              style: TextStyle(
                                fontSize: titleFontSize * 0.9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenWidth * 0.02),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.06,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(screenHeight * 0.08),
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            hint:  Text("${AppLocalizations.of(context)!.select_time}"),
                            value: selectedType,
                            isExpanded: true,
                            onChanged: (newValue) {
                              setState(() {
                                selectedType = newValue;
                              });
                            },
                            items: types.map<DropdownMenuItem<String>>((String value) {
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
                              AppLocalizations.of(context)!.description,
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
                          height: screenHeight * 0.2,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius:
                            BorderRadius.circular(screenWidth * 0.05),
                          ),
                          child: TextField(
                            controller: descriptionController,
                            maxLength: 100,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: '${AppLocalizations.of(context)!.yourdescription}',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.02,
                                vertical: screenHeight * 0.01,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.chooseimage,
                              style: TextStyle(
                                fontSize: titleFontSize * 0.9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenWidth * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                _pickImage(1);
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: screenWidth * 0.3,
                                    height: screenHeight * 0.1,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: isImageSelected
                                        ? Image.file(image!)
                                        : Icon(
                                      Icons.add,
                                      size: screenWidth * 0.05,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.04,
                  ),
                  child: ElevatedButton(
                    onPressed: _uploadFeedback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF35FF3D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      side: const BorderSide(width: 2, color: Colors.white),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1,
                        vertical: screenHeight * 0.01,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.send,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
