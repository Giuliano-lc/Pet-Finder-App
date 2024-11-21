import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:petfinder/view/my_app.dart';

void main() async {
  usePathUrlStrategy();
  FlavorConfig(variables: {
    'apiUrl': 'http://localhost:5000/',
  });
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}