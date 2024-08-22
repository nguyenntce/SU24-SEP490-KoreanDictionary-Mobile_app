import 'package:flutter/material.dart';
import 'package:myapp/pages/LoginScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class index extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA4FFB3), // Màu nền của màn hình
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.4,
                child: CustomPaint(
                  painter: CornerDashedBorderPainter(),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    // Điều chỉnh khoảng cách giữa hình ảnh và đường viền
                    child: Image.asset(
                      'assets/duahau.png', // Đường dẫn tới hình ảnh của quả dưa hấu
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              // Khoảng cách giữa hình ảnh và tiêu đề
              Text(
                AppLocalizations.of(context)!.fruitdictionary,
                // Thay đổi từ "Welcome" thành "Fruit Dictionary"
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.1,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Divider(
                // Dòng gạch ngang
                color: Colors.black,
                height: MediaQuery.of(context).size.height * 0.02,
                thickness: 3,
                indent: MediaQuery.of(context).size.width * 0.15,
                endIndent: MediaQuery.of(context).size.width * 0.15,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              // Tăng khoảng cách giữa dòng gạch ngang và nút
              ElevatedButton(
                onPressed: () {
                  // Chuyển hướng sang trang LoginScreen khi nút được nhấn
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Loginscreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                    vertical: MediaQuery.of(context).size.height * 0.02,
                  ),
                  // Điều chỉnh padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.black, width: 3), // Viền của nút
                  ),
                  backgroundColor: Color(0xFFA9FF54), // Màu nền của nút
                ),
                child: Text(
                  AppLocalizations.of(context)!.getStarted,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.08,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic, // In đậm chữ trên nút
                    color: Colors.black, // Màu chữ của nút
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CornerDashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashLength = 100.0;
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5;

    // Top-left corner
    canvas.drawLine(Offset(0, 0), Offset(dashLength, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, dashLength), paint);

    // Top-right corner
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - dashLength, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, dashLength), paint);

    // Bottom-left corner
    canvas.drawLine(Offset(0, size.height), Offset(dashLength, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - dashLength), paint);

    // Bottom-right corner
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - dashLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - dashLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
