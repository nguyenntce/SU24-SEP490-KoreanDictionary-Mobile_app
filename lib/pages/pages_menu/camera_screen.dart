import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/home_screen.dart';
import 'package:myapp/pages/pages_menu/instructions_screen.dart';
import 'package:myapp/items/corner_camera_item.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:myapp/pages/pages_menu/result_picture_screen.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );
    await _controller.initialize();
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

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              DisplayPictureScreen(imagePath: pickedFile.path),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Positioned.fill(
                  child: CameraPreview(_controller),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: Colors.white, size: screenWidth * 0.1),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      // Handle action for flash icon
                    },
                    icon: Icon(Icons.flash_on,
                        color: Colors.white, size: screenWidth * 0.1),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle action for camera icon
                    },
                    icon: Icon(Icons.camera_alt_outlined,
                        color: Colors.white, size: screenWidth * 0.1),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Container(
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.55,
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.1),
                    child: CustomPaint(
                      painter: CornerDashedBorderPainterCamera(),
                      child: Container(),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/footer_home.png',
                      width: screenWidth,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: screenHeight * 0.015,
                      right: screenWidth * 0.7,
                      child: GestureDetector(
                        onTap: _pickImageFromGallery,
                        child: Icon(
                          Icons.photo_library,
                          size: screenWidth * 0.15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: screenHeight * 0.01,
                      left: screenWidth * 0.48 - (screenWidth * 0.15 / 2),
                      child: GestureDetector(
                        onTap: () {
                          _takePicture(context);
                        },
                        child: Icon(
                          Icons.radio_button_checked,
                          size: screenWidth * 0.20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: screenHeight * 0.015,
                      left: screenWidth * 0.7,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InstructionsScreen()));
                        },
                        child: Icon(
                          Icons.question_mark,
                          size: screenWidth * 0.15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display the Picture'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_circle_right), // Biểu tượng chuyển trang
            onPressed: () {
              // Xử lý khi người dùng nhấn vào biểu tượng chuyển trang
              // Ví dụ: Chuyển sang màn hình khác
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ResultPictureScreen()),
              );
            },
          ),
        ],
      ),
      body: Image.file(File(imagePath)),
    );
  }
}

void main() => runApp(MaterialApp(home: CameraScreen()));
