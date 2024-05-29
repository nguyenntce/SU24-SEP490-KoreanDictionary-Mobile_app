import 'package:flutter/material.dart';
import 'package:myapp/pages/pages_menu/page_vocabulary/vocabulary_details_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
class VocabularyScreen extends StatefulWidget  {
  @override
  _VocabularyScreenState createState() => _VocabularyScreenState();
}
class _VocabularyScreenState extends State<VocabularyScreen> {

  final DatabaseReference _database = FirebaseDatabase.instance.reference().child('Vocabulary');
  List<Map<String, String>> vocabulary = [];
  List<Map<String, String>> filteredVocabulary = [];
  TextEditingController searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _fetchVocabulary();
    _fetchVocabulary();
    searchController.addListener(_filterVocabulary);
  }
  @override
  void dispose() {
    searchController.removeListener(_filterVocabulary);
    searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  void _fetchVocabulary() {
    _database.onValue.listen((DatabaseEvent event) {
      final List<dynamic>? values = event.snapshot.value as List<dynamic>?;
      List<Map<String, String>> tempList = [];
      if (values != null) {
        values.forEach((value) {
          if (value != null) {
            tempList.add({
              'english': value['English'] ?? '',
              'korean': value['Korean'] ?? '',
              'vietnamese': value['Vietnamese'] ?? '',
              'image': value['Fruits_img'] ?? '',
              'voice_en': value['Voice_EN'] ?? '',
              'voice_kr': value['Voice_KR'] ?? '',
              'voice_vn': value['Voice_VN'] ?? '',
              'ex_en': value['Example_EN'] ?? '',
              'ex_kr': value['Example_KR'] ?? '',
              'ex_vn': value['Example_VN'] ?? '',
            });
          }
        });
        setState(() {
          vocabulary = tempList;
          filteredVocabulary = tempList;
        });
      }
    });
  }
  void _filterVocabulary() {
    String query = searchController.text.toLowerCase();
    List<Map<String, String>> tempList = [];
    vocabulary.forEach((vocab) {
      if (vocab['english']!.toLowerCase().contains(query) ||
          vocab['korean']!.toLowerCase().contains(query) ||
          vocab['vietnamese']!.toLowerCase().contains(query)) {
        tempList.add(vocab);
      }
    });
    setState(() {
      filteredVocabulary = tempList;
    });
    print("Filtered vocabulary: $filteredVocabulary"); // Debug: In dữ liệu sau khi lọc
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;



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
          AppLocalizations.of(context)!.vocabulary,
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
        itemCount: filteredVocabulary.length + 1, // Add 1 for the search bar
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
              child: TextField(
                controller: searchController,
                focusNode: _focusNode,
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                ),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.findSomeNewWord,
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
                  leading: Image.network(
                    filteredVocabulary[vocabIndex]['image']!,
                    width: screenWidth * 0.1,
                    height: screenHeight * 0.1,
                    fit: BoxFit.contain,
                  ),
                  title: Text(
                    filteredVocabulary[vocabIndex][AppLocalizations.of(context)!.vocabularykey]!,
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle:AppLocalizations.of(context)!.localeName != 'ko' ? Text(
                    filteredVocabulary[vocabIndex]['korean']!,
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: Colors.grey[700],
                    ),
                  ):null,
                  trailing: Icon(Icons.more_vert),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VocabularyDetailsScreen(word: filteredVocabulary[vocabIndex]),
                      ),
                    );
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