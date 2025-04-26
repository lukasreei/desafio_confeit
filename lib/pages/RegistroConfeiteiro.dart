import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TelaRegistroConfeiteiro extends StatefulWidget {
  const TelaRegistroConfeiteiro({super.key});

  @override
  State<TelaRegistroConfeiteiro> createState() => _TelaRegistroConfeiteiroState();
}

class _TelaRegistroConfeiteiroState extends State<TelaRegistroConfeiteiro> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _cepController = TextEditingController();
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _estadoController = TextEditingController();
  final _cidadeController = TextEditingController();

  // Função para consultar o endereço pelo CEP
  Future<void> _consultarCep() async {
    final cep = _cepController.text.replaceAll('-', ''); // Remove hífens

    if (cep.length == 8) { // Verifica se o CEP tem o formato correto (8 dígitos)
      final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');

      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['erro'] == null) {
            setState(() {
              _ruaController.text = data['logradouro'] ?? '';
              _bairroController.text = data['bairro'] ?? '';
              _cidadeController.text = data['localidade'] ?? '';
              _estadoController.text = data['uf'] ?? '';
            });
          } else {
            _showSnackBar('CEP não encontrado.');
          }
        } else {
          _showSnackBar('Erro ao buscar o endereço.');
        }
      } catch (e) {
        _showSnackBar('Erro ao conectar com o servidor.');
      }
    } else {
      _showSnackBar('CEP inválido.');
    }
  }

  // Função para exibir mensagens de erro
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro Confeiteiro'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Crie sua conta de confeiteiro',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu e-mail';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _senhaController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Campo para o CEP
              TextFormField(
                controller: _cepController,
                decoration: const InputDecoration(
                  labelText: 'CEP',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  if (value.length == 8) {
                    _consultarCep(); // Chama a função ao preencher o CEP
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu CEP';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Campo para a Rua
              TextFormField(
                controller: _ruaController,
                decoration: const InputDecoration(
                  labelText: 'Rua',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da sua rua';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Campo para o Número
              TextFormField(
                controller: _numeroController,
                decoration: const InputDecoration(
                  labelText: 'Número',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o número da sua residência';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Campo para o Bairro
              TextFormField(
                controller: _bairroController,
                decoration: const InputDecoration(
                  labelText: 'Bairro',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu bairro';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Campo para o Estado
              TextFormField(
                controller: _estadoController,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu estado';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Campo para a Cidade
              TextFormField(
                controller: _cidadeController,
                decoration: const InputDecoration(
                  labelText: 'Cidade',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua cidade';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Implementar a lógica para registrar o confeiteiro aqui
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registrado com sucesso!')),
                    );
                    // Redirecionar para login ou outra tela
                    Navigator.pushNamed(context, '/loginConfeiteiro');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Registrar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
