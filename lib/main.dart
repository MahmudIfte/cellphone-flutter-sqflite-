import 'package:cellphone/home_page.dart';
import 'package:flutter/material.dart';
import 'package:cellphone/sqflite.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure that the database is initialized before running the application
  await DatabaseHelper.instance.database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 52, 181, 235)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
