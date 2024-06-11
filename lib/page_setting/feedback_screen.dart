import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  List<String> types = [
    'Vocabulary',
    'Take Picture',
    'Quiz',
    'Flashcard',
    'Other'
  ];
  String? selectedType;

  File? image;

  bool isImageSelected = false;

  Future<void> _pickImage(int boxNumber) async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery, // Chọn hình từ thư viện ảnh
      // source: ImageSource.camera, // Chọn hình từ máy ảnh
    );
    if (pickedImage != null) {
      setState(() {
        // Cập nhật hình ảnh đã chọn vào biến tương ứng
        if (boxNumber == 1) {
          image = File(pickedImage.path);
          isImageSelected =
              true; // Đặt biến isImage1Selected thành true khi chọn hình ảnh
        }
      });
    }
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
          return SingleChildScrollView(
            // Sử dụng SingleChildScrollView thay vì CustomScrollView
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
                          height: screenHeight * 0.06,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.black,
                                width:
                                    2.0), // Điều chỉnh kích thước border ở đây
                            borderRadius:
                                BorderRadius.circular(screenHeight * 0.1),
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              border: InputBorder
                                  .none, // Để loại bỏ border mặc định của DropdownButtonFormField
                            ),
                            hint: const Text("Select Type"),
                            value: selectedType,
                            isExpanded: true,
                            onChanged: (newValue) {
                              setState(() {
                                selectedType = newValue;
                              });
                            },
                            items: types
                                .map<DropdownMenuItem<String>>((String value) {
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
                          height: screenHeight * 0.2,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.05),
                          ),
                          child: TextField(
                            maxLength: 100,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: 'Your description...',
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
                              'Choose Image',
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
                    onPressed: () {
                      // Code xử lý khi nhấn nút Send
                    },
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
                        'Send',
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
