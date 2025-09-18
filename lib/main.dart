import 'package:flutter/material.dart';
import 'package:tic_tac_toe_impossible/pages/mode_selection_page.dart';
import 'package:tic_tac_toe_impossible/pages/tic_toe_tac_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ModeSelectionPage(),
    );
  }
}
