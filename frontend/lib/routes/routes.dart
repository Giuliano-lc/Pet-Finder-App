
import 'package:flutter/material.dart';

import '../view/home_view.dart';
import '../view/login_view.dart';
import '../view/page_not_found_view.dart';


Route<dynamic> webRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(settings: settings, builder: (_) => const LoginView());
    case '/home':
      return MaterialPageRoute(
          settings: settings, builder: (_) => const HomeView());
    default:
      return MaterialPageRoute(
          builder: (_) => PageNotFoundView(routeName: settings.name));
  }
}