import 'package:flutter/material.dart';

class CareerForgeApp extends StatelessWidget {
  const CareerForgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareerForge',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CareerForge'),
        ),
        body: const Center(
          child: Text('CareerForge App Initialized'),
        ),
      ),
    );
  }
}
