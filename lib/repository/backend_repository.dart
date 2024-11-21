import 'package:dio/dio.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

class BackendRepository {
  final dio = Dio(
      BaseOptions(
          baseUrl: FlavorConfig.instance.variables['apiUrl']
      )
  );
}