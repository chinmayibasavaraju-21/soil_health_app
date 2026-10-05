import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const SoilHealthApp());
}

class SoilHealthApp extends StatelessWidget {
  const SoilHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soil Health Advisory',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Roboto'),
      home: const HomeScreen(),
    );
  }
}
