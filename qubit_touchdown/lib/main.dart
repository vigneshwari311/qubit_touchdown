import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qubit_touchdown/constants.dart';
import 'package:qubit_touchdown/provider/game.dart';
import 'package:qubit_touchdown/screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameProvider()..initializeGame(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Qubit TouchDown",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: ColorConstants.scaffoldBackgroundColor,
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontFamily: 'BitcountSingle',
            fontSize: 22,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
      ),
      builder: (context, child) {
        return FixedWidthScaffold(child: child!);
      },
      home: HomeScreen(),
    );
  }
}

class FixedWidthScaffold extends StatelessWidget {
  final Widget child;
  static const double maxGameWidth = 450.0;
  const FixedWidthScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android && !kIsWeb) {
      return Scaffold(body: child);
    }
    return Container(
      color: Colors.black,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxGameWidth),
          child: child,
        ),
      ),
    );
  }
}
