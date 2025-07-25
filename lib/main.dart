import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weatherandnewsaggregatorapp/presentation/pages/bottom_bar/bottom_bar_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      home: const MainScreen(),
    );
  }
}
