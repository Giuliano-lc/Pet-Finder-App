import 'package:flutter/material.dart';
import 'package:petfinder/bloc/login_bloc.dart';

import '../design_configs.dart';

void showRegisterModal(BuildContext context, LoginBloc bloc) {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        insetPadding: const EdgeInsets.all(14),
        titlePadding: const EdgeInsets.all(5),
        backgroundColor: DesignConfigs.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 30),
        title: Container(
          decoration: BoxDecoration(
            color: DesignConfigs.brownColor,
            borderRadius: BorderRadius.circular(3.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: Text(
            'Cadastrar',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 26,
              color: DesignConfigs.whiteColor,
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Nome completo"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Informe o nome completo";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: bloc.validateRegisterEmail
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: "Senha"),
                  obscureText: true,
                  validator: bloc.validateRegisterPassword
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(labelText: "Confirmar senha"),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirme a senha";
                    }
                    if (value != passwordController.text) {
                      return "As senhas não coincidem";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                bool registerSuccess = await bloc.registerUser(
                    nameController.text,
                    emailController.text,
                    passwordController.text
                );
                String msg = registerSuccess ? 'Cadastro realizado com sucesso!' : 'Não foi possivel realizar o cadastro!';
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(msg),
                      )
                  );
                  Navigator.pop(context);
                }
              }
            },
            child: const Text("Cadastrar"),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: DesignConfigs.orangeColor,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Voltar para o login"),
          ),
        ],
      );
    },
  );
}
