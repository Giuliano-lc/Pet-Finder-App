import 'package:flutter/material.dart';

import '../repository/shared_preferences_repository.dart';
import '../use_case/login_use_case.dart';

class LoginBloc {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;

  void dispose() {
    userController.dispose();
    passwordController.dispose();
  }

  bool validateLogin() {
    bool authenticate = LoginUseCase.login(userController.text, passwordController.text);
    if (authenticate) {
      // TODO: Retirar esse 'Token' Salvo e validar ele com o Backend
      SharedPreferencesRepository.setUserToken('ExemploDeToken');
    }
    return authenticate;
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

  // TODO: Falta um endpoint para registrar de fato o usuário
  Future<bool> registerUser(
      String name,
      String email,
      String password
      ) async {
    return true;
  }


  void clearControllers() {
    userController.text = '';
    passwordController.text='';
  }
}