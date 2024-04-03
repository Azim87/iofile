import 'package:flutter/material.dart';
import 'package:iofile/iofile.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(home: IOFileScreen());
}
