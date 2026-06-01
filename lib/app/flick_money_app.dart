import 'package:flutter/material.dart';

import '../features/reward_reveal/reward_reveal_screen.dart';

class FlickMoneyApp extends StatelessWidget {
  const FlickMoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlickPay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE4D50A),
          brightness: Brightness.dark,
        ),
      ),
      home: const RewardRevealScreen(),
    );
  }
}
