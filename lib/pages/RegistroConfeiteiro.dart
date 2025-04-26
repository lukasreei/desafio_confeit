import 'package:desafio_confeit/banco/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CadastroConfeitariaPage extends StatefulWidget {
  @override
  _CadastroConfeitariaPageState createState() => _CadastroConfeitariaPageState();
}

class _CadastroConfeitariaPageState extends State<CadastroConfeitariaPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _avaliacaoController = TextEditingController();
  final TextEditingController _imagemController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(); // Novo controlador

  // Função para buscar o endereço pelo CEP
  Future<void> _buscarEnderecoPorCEP(String cep) async {
    if (cep.isEmpty || cep.length != 8) return; // Verifica se o CEP tem 8 dígitos
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['erro'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CEP não encontrado!')));
        return;
      }
      setState(() {
        _ruaController.text = data['logradouro'] ?? '';
        _bairroController.text = data['bairro'] ?? '';
        _cidadeController.text = data['localidade'] ?? '';
        _estadoController.text = data['uf'] ?? '';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao buscar endereço!')));
    }
  }

  // Função para cadastrar a confeitaria no banco de dados
  Future<void> _cadastrarConfeitaria() async {
    if (_formKey.currentState!.validate()) {
      // Criar o mapa de dados para salvar no banco de dados
      final newConfeitaria = {
        'nome': _nomeController.text,
        'avaliacao': double.parse(_avaliacaoController.text),
        'imagem': _imagemController.text,  // URL ou caminho da imagem
        'endereco': _enderecoController.text,
        'cep': _cepController.text,
        'rua': _ruaController.text,
        'numero': _numeroController.text,
        'bairro': _bairroController.text,
        'estado': _estadoController.text,
        'cidade': _cidadeController.text,
        'email': _emailController.text,  // Adicionando o email ao mapa
      };

      // Inserir no banco de dados
      await DatabaseHelper.instance.insertConfeitaria(newConfeitaria);

      // Após cadastrar, você pode voltar para a lista de confeitarias ou mostrar um Snackbar de sucesso
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Confeitaria cadastrada com sucesso!')));
      Navigator.pop(context);  // Voltar para a página anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Confeitaria'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome da Confeitaria'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome da confeitaria';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _avaliacaoController,
                decoration: InputDecoration(labelText: 'Avaliação (0 a 5)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a avaliação';
                  }
                  if (double.tryParse(value) == null || double.parse(value) < 0 || double.parse(value) > 5) {
                    return 'Avaliação deve ser entre 0 e 5';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imagemController,
                decoration: InputDecoration(labelText: 'URL da Imagem'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a URL da imagem';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController, // Campo de email
                decoration: InputDecoration(labelText: 'E-mail'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o e-mail da confeitaria';
                  }
                  // Validação simples de email
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Informe um e-mail válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: InputDecoration(labelText: 'Endereço'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o endereço da confeitaria';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cepController,
                decoration: InputDecoration(labelText: 'CEP'),
                keyboardType: TextInputType.number,
                onChanged: (cep) {
                  if (cep.length == 8) {
                    _buscarEnderecoPorCEP(cep);  // Preenche o endereço quando o CEP tiver 8 caracteres
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o CEP';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ruaController,
                decoration: InputDecoration(labelText: 'Rua'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a rua';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _numeroController,
                decoration: InputDecoration(labelText: 'Número'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o número';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bairroController,
                decoration: InputDecoration(labelText: 'Bairro'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o bairro';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _estadoController,
                decoration: InputDecoration(labelText: 'Estado'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o estado';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cidadeController,
                decoration: InputDecoration(labelText: 'Cidade'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a cidade';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _cadastrarConfeitaria,
                child: Text('Cadastrar Confeitaria'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
