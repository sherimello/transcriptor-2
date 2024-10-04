import 'package:flutter/material.dart';
import 'package:transcriptor/home.dart';
import 'package:transcriptor/speech_to_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: STP(),
    );
  }
}
