import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AnimalRegistrationScreen extends StatefulWidget {
  const AnimalRegistrationScreen({super.key});

  @override
  AnimalRegistrationScreenState createState() =>
      AnimalRegistrationScreenState();
}

class AnimalRegistrationScreenState extends State<AnimalRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  final _ageController = TextEditingController();
  final _ownerController = TextEditingController();
  File? _uploadedImage;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _uploadedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _registerAnimal() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://127.0.0.1:5000/cadastrar_animal'),
      );

      request.fields.addAll({
        'nome': _nameController.text,
        'especie': _speciesController.text,
        'idade': _ageController.text,
        'dono': _ownerController.text,
      });

      if (_uploadedImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('foto', _uploadedImage!.path),
        );
      }

      final response = await request.send();
      final message = response.statusCode == 200
          ? 'Animal cadastrado com sucesso!'
          : 'Falha ao cadastrar o animal. Tente novamente.';
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar Animal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome do animal'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor, insira o nome do animal'
                    : null,
              ),
              TextFormField(
                controller: _speciesController,
                decoration: InputDecoration(labelText: 'Espécie'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor, insira a espécie'
                    : null,
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a idade';
                  }
                  return int.tryParse(value) == null
                      ? 'A idade deve ser um número válido'
                      : null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _uploadedImage != null
                      ? Image.file(
                          _uploadedImage!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Text('Nenhuma foto selecionada'),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Upload Foto'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ownerController,
                decoration: InputDecoration(labelText: 'Nome do dono'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor, insira o nome do dono'
                    : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _registerAnimal,
                child: Text('Cadastrar Animal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
