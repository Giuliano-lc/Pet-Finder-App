import 'package:flutter/material.dart';
import 'package:petfinder/bloc/login_bloc.dart';

import '../design_configs.dart';
import '../repository/shared_preferences_repository.dart';
import '../widget/login_app_bar.dart';
import '../widget/register_modal.dart';
import '../widget/warning_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final bloc = LoginBloc();

  @override
  void initState() {
    super.initState();
    checkUserIsLoggedAndRedirect();
  }

  void checkUserIsLoggedAndRedirect() async {
    if (await SharedPreferencesRepository.getUserToken() != null && mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  void _login() {
    if (bloc.userController.text == '' || bloc.passwordController.text == '') {
      showWarningDialog(
          context: context,
          title: 'Aviso',
          content: 'Por favor, informe login e senha para entrar na aplicação!',
          actionText: 'Entendi',
          function: () {
            Navigator.pop(context);
          });
      return;
    } else if (!bloc.validateLogin()) {
      showWarningDialog(
          context: context,
          title: 'Login Inválido',
          content:
          'As credenciais informadas não são válidas, por favor, tente novamente!',
          actionText: 'Entendi',
          function: () {
            bloc.clearControllers();
            Navigator.pop(context);
          });
      return;
    }

    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: loginAppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 700,
              minWidth: 300,
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width * .8,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: AutofillGroup(
              child: Column(
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                        color: DesignConfigs.brownColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 26),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    autofillHints: const [AutofillHints.username],
                    controller: bloc.userController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Usuário",
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    autofillHints: const [AutofillHints.password],
                    obscureText: !bloc.passwordVisible,
                    controller: bloc.passwordController,
                    decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(bloc.passwordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          onPressed: () {
                            setState(() {
                              bloc.passwordVisible = !bloc.passwordVisible;
                            });
                          },
                        ),
                        suffixIconColor: DesignConfigs.orangeColor),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: _login, child: const Text('Entrar')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: DesignConfigs.orangeColor,
                    ),
                    onPressed: (){},
                    child: const Text(
                      'Esqueci minha senha!',
                      style: TextStyle(
                        fontSize: 18
                      ),
                    )
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: DesignConfigs.orangeColor,
                      ),
                      onPressed: () => showRegisterModal(context, bloc),
                      child: const Text(
                        'Cadastrar',
                        style: TextStyle(
                            fontSize: 18
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
