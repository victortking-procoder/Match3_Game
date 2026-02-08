import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screens/game_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const Match3Game());
}

class Match3Game extends StatelessWidget {
  const Match3Game({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Match 3 Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
