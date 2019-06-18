import 'package:flutter/material.dart';
import 'package:present_sir/ui/dashboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Present Sir',
      home: Dashboard(),
    );
  }
}

