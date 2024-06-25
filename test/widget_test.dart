import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/firebase_options.dart';

void main() {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Xây dựng ứng dụng và kích hoạt một khung hình
    await tester.pumpWidget(MyApp());

    // Kiểm tra rằng bộ đếm bắt đầu từ 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Nhấn vào biểu tượng '+' và kích hoạt một khung hình
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Kiểm tra rằng bộ đếm đã tăng lên 1
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
