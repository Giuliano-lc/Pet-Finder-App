import 'package:flutter/material.dart';
import 'widgets/cadastro.dart'; // Certifique-se de usar o caminho correto para o arquivo
import 'widgets/listagem.dart'; // Certifique-se de usar o caminho correto para o arquivo

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Animais',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/register': (context) => AnimalRegistrationScreen(),
        '/list': (context) => AnimalListScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Inicial'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Cadastrar Animal'),
            ),
            SizedBox(height: 16), // Espaço entre os botões
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/list');
              },
              child: Text('Listar Animais'),
            ),
          ],
        ),
      ),
    );
  }
}
