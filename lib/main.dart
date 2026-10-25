import 'package:flutter/material.dart';
import 'data/game_repository.dart';
import 'pages/home_page.dart';

void main() => runApp(const GameShelfApp());

class GameShelfApp extends StatelessWidget {
  const GameShelfApp({super.key, this.repository});
  final GameRepository? repository;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'GameShelf',
    theme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF10121B),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFA89AFF), brightness: Brightness.dark),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF10121B), centerTitle: false),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: const Color(0xFF202331),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none)),
    ),
    home: HomePage(repository: repository ?? LocalGameRepository()),
  );
}
