import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:myapp/items/corner_camera_item.dart';
import 'package:myapp/pages/pages_menu/instructions_screen.dart';
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
  bool _isFlashOn = false;
  int _selectedCameraIndex = 0;
  List<CameraDescription>? _cameras;
  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras![_selectedCameraIndex],
        ResolutionPreset.high,
      );
      await _controller.initialize();
      if (mounted) {
        setState(() {});
      }
    } else {
      // Handle case where no cameras are available
      print("No cameras available");
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



      // Chụp ảnh
      final image = await _controller.takePicture();

      // Tắt đèn flash ngay sau khi chụp ảnh
      await _controller.setFlashMode(FlashMode.off);

      if (!mounted) return;

      // Chuyển đến trang kết quả ảnh
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultPictureScreen(imagePath: image.path),
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
              ResultPictureScreen(imagePath: pickedFile.path),
        ),
      );
    }
  }
  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
      _controller.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
    });
  }

  void _switchCamera() {
    setState(() {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
      _initializeCamera();
    });
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
                return SizedBox(
                  height: screenHeight,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: RotatedBox(
                      quarterTurns: 0, // Xoay camera 90 độ để hiển thị theo hướng dọc
                      child: CameraPreview(_controller),
                    ),
                  ),
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
                    onPressed: _toggleFlash,
                    icon: Icon(
                      _isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                      size: screenWidth * 0.1,
                    ),
                  ),
                  IconButton(
                    onPressed: _switchCamera,
                    icon: Icon(Icons.cameraswitch,
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
