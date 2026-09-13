import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/game_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cố định hướng màn hình ngang (Landscape) cho App mobile
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Ẩn thanh trạng thái và thanh điều hướng (Fullscreen) cho App mobile
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat Defense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
      home: const GameScreen(),
    );
  }
}
