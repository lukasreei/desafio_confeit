import 'package:desafio_confeit/banco/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Certifique-se de importar seu helper de banco de dados

class CadastroProdutoPage extends StatefulWidget {
  final int confeitariaId;

  CadastroProdutoPage({required this.confeitariaId});

  @override
  _CadastroProdutoPageState createState() => _CadastroProdutoPageState();
}

class _CadastroProdutoPageState extends State<CadastroProdutoPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  File? _imagem;

  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagem = File(pickedFile.path);
      });
    }
  }

  // Função para cadastrar o produto
  Future<void> _cadastrarProduto() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (_imagem == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selecione uma imagem!')));
          return;
        }

        // Criar o mapa de dados para salvar no banco
        final newProduto = {
          'nome': _nomeController.text,
          'descricao': _descricaoController.text,
          'valor': double.parse(_valorController.text),
          'imagem': _imagem!.path, // Salvar o caminho local da imagem
          'confeitariaId': widget.confeitariaId,
        };

        // Salvar no banco (adapte conforme seu método de inserção)
        await DatabaseHelper.instance.insertProduto(newProduto);

        // Limpar campos após o cadastro
        _nomeController.clear();
        _descricaoController.clear();
        _valorController.clear();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Produto cadastrado com sucesso!')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao cadastrar produto: $e')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Produto'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo Nome do Produto
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome do Produto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome do produto';
                  }
                  return null;
                },
              ),
              // Campo Descrição
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a descrição do produto';
                  }
                  return null;
                },
              ),
              // Campo Valor
              TextFormField(
                controller: _valorController,
                decoration: InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o valor do produto';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Valor inválido';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  _imagem == null
                      ? Text('Nenhuma imagem selecionada')
                      : Image.file(_imagem!, width: 100, height: 100, fit: BoxFit.cover),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Selecionar Imagem'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Botão de Cadastro
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _cadastrarProduto,
                child: Text('Cadastrar Produto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
