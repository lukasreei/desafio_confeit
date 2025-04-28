import 'dart:io';
import 'package:desafio_confeit/banco/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  File? _imagem;
  final ImagePicker _picker = ImagePicker();

  // Função para selecionar uma imagem da galeria
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagem = File(pickedFile.path); // Armazenando o arquivo de imagem
        _imagemController.text = pickedFile.path; // Preenche o campo com o caminho da imagem
      });
    }
  }

  Future<void> _buscarEnderecoPorCEP(String cep) async {
    if (cep.isEmpty || cep.length != 8) return;
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

  Future<void> _cadastrarConfeitaria() async {
    if (_formKey.currentState!.validate()) {
      final newConfeitaria = {
        'nome': _nomeController.text,
        'avaliacao': double.parse(_avaliacaoController.text),
        'imagem': _imagemController.text,
        'endereco': _enderecoController.text,
        'cep': _cepController.text,
        'rua': _ruaController.text,
        'numero': _numeroController.text,
        'bairro': _bairroController.text,
        'estado': _estadoController.text,
        'cidade': _cidadeController.text,
        'email': _emailController.text,
        'senha': _senhaController.text,
      };

      await DatabaseHelper.instance.insertConfeitaria(newConfeitaria);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Confeitaria cadastrada com sucesso!')));
      Navigator.pop(context);
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome da Confeitaria',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o nome da confeitaria';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _avaliacaoController,
                  decoration: InputDecoration(
                    labelText: 'Avaliação (0 a 5)',
                    border: OutlineInputBorder(),
                  ),
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
                SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o e-mail da confeitaria';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Informe um e-mail válido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _senhaController,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a senha';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter no mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _enderecoController,
                  decoration: InputDecoration(
                    labelText: 'Endereço',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o endereço da confeitaria';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _cepController,
                  decoration: InputDecoration(
                    labelText: 'CEP',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (cep) {
                    if (cep.length == 8) {
                      _buscarEnderecoPorCEP(cep);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o CEP';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _ruaController,
                  decoration: InputDecoration(
                    labelText: 'Rua',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a rua';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _numeroController,
                  decoration: InputDecoration(
                    labelText: 'Número',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o número';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _bairroController,
                  decoration: InputDecoration(
                    labelText: 'Bairro',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o bairro';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _estadoController,
                  decoration: InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o estado';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _cidadeController,
                  decoration: InputDecoration(
                    labelText: 'Cidade',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a cidade';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _imagemController,
                  decoration: InputDecoration(
                    labelText: 'URL da Imagem',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a URL da imagem';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Escolher Imagem'),
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
      ),
    );
  }
}
