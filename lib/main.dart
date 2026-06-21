import 'package:flutter/material.dart';

import 'core/theme/app_colors.dart';
import 'features/home/home_screen.dart';

void main() {
  runApp(const FieldAiAssistApp());
}

class FieldAiAssistApp extends StatelessWidget {
  const FieldAiAssistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FieldAI Assist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryNavy,
          primary: AppColors.primaryNavy,
        ),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}
