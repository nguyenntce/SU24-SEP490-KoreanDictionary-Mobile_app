import 'package:flutter/material.dart';

class AboutusScreen extends StatefulWidget {
  @override
  _AboutusScreenState createState() => _AboutusScreenState();
}

class _AboutusScreenState extends State<AboutusScreen> {
  late PageController _pageController;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.8, // Tỷ lệ của mỗi trang
    );
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleFontSize = screenWidth * 0.05;
    double imageSize = screenWidth * 0.3; // Kích thước của hình ảnh
    double imageContainerHeight =
        screenHeight * 0.25; // Chiều cao của container chứa hình ảnh
    double tableHeight = screenHeight * 1;

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
          'About Us',
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
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
              child: Column(
                children: [
                  Container(
                    height: imageContainerHeight * 0.4,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child:
                          Container(), // Container trống để căn giữa hình ảnh
                        ),
                        Container(
                          width: imageSize * 0.6,
                          // Tăng kích thước của hình ảnh lên
                          height: imageSize * 0.6,
                          // Tăng kích thước của hình ảnh lên
                          decoration: const BoxDecoration(
                            // Đảm bảo hình ảnh là hình tròn
                            image: DecorationImage(
                              image: AssetImage('assets/avocado.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          padding: const EdgeInsets.all(
                              4.0), // Tạo viền bằng cách thêm padding
                        ),
                        Expanded(
                          child:
                          Container(), // Container trống để căn giữa hình ảnh
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Fruit Dictionary',
                    style: TextStyle(
                      fontSize: titleFontSize * 2,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    'Version 1.0',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              height: tableHeight * 0.15,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.00),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: titleFontSize * 1.2,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    // SizedBox(height: screenHeight * 0), // Add some spacing
                    Text(
                      'So that children can accurately recognize fruits and help children learn Korean through pictures and voices conveniently.',
                      style: TextStyle(
                        fontSize: titleFontSize * 0.9,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              height: screenHeight * 0.35,
              child: PageView.builder(
                controller: _pageController,
                itemCount: 5, // Số lượng hình ảnh
                itemBuilder: (BuildContext context, int index) {
                  double scale = 1.0;
                  if (index == _currentPage) {
                    scale = 1.0;
                  } else {
                    scale = 0.8;
                  }
                  return Transform.scale(
                    scale: scale,
                    child: Image.asset(
                      // Danh sách các hình ảnh
                      index == 0
                          ? 'assets/about_us.png'
                          : index == 1
                          ? 'assets/about_us.png'
                          : index == 2
                          ? 'assets/about_us.png'
                          : index == 3
                          ? 'assets/about_us.png'
                          : 'assets/about_us.png',
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.35,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.00),
            Container(
              margin: EdgeInsets.only(
                  top: screenHeight * 0.00, left: screenWidth * 0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Contact Us Below!',
                style: TextStyle(
                  fontSize: titleFontSize * 1.2,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.00),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.facebook,
                        size: titleFontSize * 4), // Tăng kích thước
                    onPressed: () {
                      // Xử lý khi nhấn vào biểu tượng Facebook
                      // Chuyển hướng đến đường link Facebook
                    },
                  ),
                  SizedBox(
                      width: screenWidth *
                          0.15), // Khoảng cách giữa các biểu tượng
                  IconButton(
                    icon: Icon(Icons.email,
                        size: titleFontSize * 4), // Tăng kích thước
                    onPressed: () {
                      // Xử lý khi nhấn vào biểu tượng Email
                      // Ví dụ: Mở ứng dụng email mặc định của người dùng
                    },
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