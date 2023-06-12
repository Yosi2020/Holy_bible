import 'package:flutter/material.dart';
import 'package:metsaf1/home.dart';
import 'package:metsaf1/pdf.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PdfViewerPage(),
    );
  }
}
