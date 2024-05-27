import 'package:flutter/material.dart';
import 'package:myapp/pages/pages_menu/page_vocabulary/vocabulary_details_screen.dart';
class VocabularyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    List<Map<String, String>> vocabulary = [
      {'english': 'Banana', 'korean': '바나나', 'image': 'assets/banana.png'},
      {'english': 'Strawberry', 'korean': '딸기', 'image': 'assets/strawberry.png'},
      {'english': 'Watermelon', 'korean': '수박', 'image': 'assets/watermelon.png'},
      {'english': 'Cherry', 'korean': '체리', 'image': 'assets/cherry.png'},
      {'english': 'Avocado', 'korean': '아보카도', 'image': 'assets/avocado.png'},
      {'english': 'Wax Apple', 'korean': '왁스 사과', 'image': 'assets/wax_apple.png'},
      {'english': 'Kiwi', 'korean': '키위', 'image': 'assets/kiwi.png'},
      {'english': 'Logan', 'korean': '롱안', 'image': 'assets/logan.png'},
      {'english': 'Logan', 'korean': '롱안', 'image': 'assets/logan.png'},
      {'english': 'Logan', 'korean': '롱안', 'image': 'assets/logan.png'},
      {'english': 'Logan', 'korean': '롱안', 'image': 'assets/logan.png'},
      {'english': 'Logan', 'korean': '롱안', 'image': 'assets/logan.png'},


    ];

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
          'Vocabulary',
          style: TextStyle(
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: vocabulary.length + 1, // Add 1 for the search bar
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
              child: TextField(
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                ),
                decoration: InputDecoration(
                  hintText: 'Find Some New Word?',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.08),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: screenWidth * 0.006,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.08),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: screenWidth * 0.007,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.08),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: screenWidth * 0.008,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: screenWidth * 0.1,
                    color: Colors.black,
                  ),
                  contentPadding: EdgeInsets.fromLTRB(
                    screenWidth * 0.02,
                    screenWidth * 0.01,
                    screenWidth * 0.02,
                    screenWidth * 0.07,
                  ),
                ),
              ),
            );
          } else {
            int vocabIndex = index - 1; // Adjust index for the vocabulary list
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.01,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                ),
                child: ListTile(
                  leading: Image.asset(
                    vocabulary[vocabIndex]['image']!,
                    width: screenWidth * 0.1,
                    height: screenHeight * 0.1,
                    fit: BoxFit.contain,
                  ),
                  title: Text(
                    vocabulary[vocabIndex]['english']!,
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    vocabulary[vocabIndex]['korean']!,
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: Colors.grey[700],
                    ),
                  ),
                  trailing: Icon(Icons.more_vert),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VocabularyDetailsScreen()));
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
