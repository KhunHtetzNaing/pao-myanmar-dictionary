import 'package:flutter/material.dart';
import 'package:pao_myanmar_dictionary/ui/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Pa'O Myanmar Dictionary",
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
            fontFamily: 'Pyidaungsu'),
        darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green, brightness: Brightness.dark),
            useMaterial3: true,
            fontFamily: 'Pyidaungsu'),
        themeMode: ThemeMode.light,
        home: HomePage());
  }
}
