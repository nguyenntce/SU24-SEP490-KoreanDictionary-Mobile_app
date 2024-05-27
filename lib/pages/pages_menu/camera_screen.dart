import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture(BuildContext context) async {
    try {
      await _initializeControllerFuture;

      final image = await _controller.takePicture();

      if (!mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(imagePath: image.path),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Tính toán padding và kích thước dựa trên kích thước màn hình
    double horizontalPadding = screenWidth * 0.03; // 5% của chiều rộng màn hình
    double verticalPadding = screenHeight * 0.02; // 2% của chiều cao màn hình

    return Scaffold(
      backgroundColor: Color(0xFFA4FFB3),
      body: Column(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Spacer(),
          // Thêm footer là hình ảnh
          Container(
            width: double.infinity,
            child: Stack(
              children: [
                Image.asset(
                  'assets/footer_home.png',
                  width: screenWidth,
                  // Thay đường dẫn tới hình ảnh footer
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: screenHeight * 0.015,
                  right: screenWidth * 0.7,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'assets/photo.png',
                      width: screenWidth *
                          0.15, // Kích thước icon dựa trên chiều rộng màn hình
                    ),
                  ),
                ),
                Positioned(
                  bottom: screenHeight * 0.01,
                  left: screenWidth * 0.48 - (screenWidth * 0.15 / 2),
                  // Đặt vị trí ngang cho hình ảnh camera
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CameraScreen()));
                    },
                    child: Image.asset(
                      'assets/footer_camera.png',
                      width: screenWidth *
                          0.20, // Kích thước icon dựa trên chiều rộng màn hình
                    ),
                  ),
                ),
                Positioned(
                  bottom: screenHeight * 0.01,
                  left: screenWidth * 0.7,
                  child: GestureDetector(
                    onTap: () {

                    },
                    child: Image.asset(
                      'assets/instructions.png',
                      width: screenWidth * 0.2,
                      // Kích thước icon dựa trên chiều rộng màn hình
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}

void main() => runApp(MaterialApp(home: CameraScreen()));
