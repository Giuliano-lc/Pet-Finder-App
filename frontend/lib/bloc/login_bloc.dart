import 'package:flutter/material.dart';

import '../repository/shared_preferences_repository.dart';
//import '../use_case/login_use_case.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginBloc {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;

  void dispose() {
    userController.dispose();
    passwordController.dispose();
  }

  Future<bool> loginUser(String email, String password) async {
    final url = Uri.parse('http://localhost:5000/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'email': email,
      'senha': password,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Login bem-sucedido
        final responseData = jsonDecode(response.body);
        final token = responseData['access_token'];
        await SharedPreferencesRepository.setUserToken(token);
        return true;
      } else {
        // Trate erros retornados pelo servidor
        print('Erro: ${response.body}');
        return false;
      }
    } catch (e) {
      // Trate erros de conexão ou outros problemas
      print('Erro ao se conectar ao servidor: $e');
      return false;
    }
  }

  Future<bool> validateLogin() async {
    String email = userController.text;
    String password = passwordController.text;

    bool isAuthenticated = await loginUser(email, password);

    if (isAuthenticated) {
      print('Login realizado com sucesso!');
    } else {
      print('Erro no login, verifique suas credenciais.');
    }

    return isAuthenticated;
  }

  String? validateRegisterPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Informe a senha";
    }
    if (value.length < 8 ||
        !RegExp(r'[A-Z]').hasMatch(value) ||
        !RegExp(r'[a-z]').hasMatch(value) ||
        !RegExp(r'[0-9]').hasMatch(value) ||
        !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return "Senha deve ter pelo menos 8 caracteres, incluindo maiúscula, minúscula, número e símbolo";
    }
    return null;
  }

  String? validateRegisterEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Informe o email";
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return "Informe um email válido";
    }
    // TODO: Por enquanto estamos simulando um email, depois trocamos para algum endpoint do backend
    if (value == "email.ja@cadastrado.com") {
      return "Email já cadastrado";
    }
    return null;
  }

  Future<bool> registerUser(String name, String email, String password) async {
    final url = Uri.parse('http://localhost:5000/cadastro');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'nome': name,
      'email': email,
      'senha': password,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Registro bem-sucedido
        return true;
      } else {
        // Trate erros retornados pelo servidor
        print('Erro: ${response.body}');
        return false;
      }
    } catch (e) {
      // Trate erros de conexão ou outros problemas
      print('Erro ao se conectar ao servidor: $e');
      return false;
    }
  }

  void clearControllers() {
    userController.text = '';
    passwordController.text = '';
  }
}
