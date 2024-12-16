// Flutter Frontend
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const AnimalListApp());
}

class AnimalListApp extends StatelessWidget {
  const AnimalListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AnimalListScreen(),
    );
  }
}

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

  @override
  AnimalListScreenState createState() => AnimalListScreenState();
}

class AnimalListScreenState extends State<AnimalListScreen> {
  List<dynamic> _animals = [];
  final TextEditingController _filterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAnimals("todos");
  }

  Future<void> _fetchAnimals(String filter) async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:5000/listar_animais/$filter'));
    if (response.statusCode == 200) {
      setState(() {
        _animals = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load animals');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _filterController,
              decoration: const InputDecoration(
                labelText: 'Filtrar animais',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _fetchAnimals(value);
              },
            ),
          ),
          Expanded(
            child: _animals.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _animals.length,
                    itemBuilder: (context, index) {
                      final animal = _animals[index];
                      return Card(
                        child: ListTile(
                          leading: Image.network(animal['image'] ?? ''),
                          title: Text(animal['name'] ?? 'Nome não disponível'),
                          subtitle: Text(
                              'Espécie: ${animal['species'] ?? 'N/A'} | Idade: ${animal['age'] ?? 'N/A'}'),
                          trailing: ElevatedButton(
                            child: const Text('Ver Detalhes'),
                            onPressed: () async {
                              final currentContext =
                                  context; // Captura o BuildContext atual
                              final detailsResponse = await http.get(Uri.parse(
                                  'http://127.0.0.1:5000/listar/${animal['id']}'));
                              if (detailsResponse.statusCode == 200) {
                                final details =
                                    json.decode(detailsResponse.body);
                                if (!mounted) return;
                                // Exibir diálogo usando o BuildContext capturado
                                showDialog(
                                  context: currentContext,
                                  builder: (context) => AlertDialog(
                                    title: Text(details['name'] ?? 'Sem Nome'),
                                    content: Text(
                                        'Espécie: ${details['species'] ?? 'N/A'}\n'
                                        'Idade: ${details['age'] ?? 'N/A'}\n'
                                        'Dono: ${details['owner'] ?? 'Não especificado'}'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(currentContext),
                                        child: const Text('Fechar'),
                                      )
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
