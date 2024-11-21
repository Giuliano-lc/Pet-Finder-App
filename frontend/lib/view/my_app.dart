import 'package:flutter/material.dart';
import '../../themes.dart';
import '../routes/routes.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetFinder',
      theme: defaultTheme(),
      onGenerateRoute: webRoute,
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
