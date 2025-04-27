import 'package:flutter/material.dart';
import 'package:desafio_confeit/banco/database_helper.dart'; // Certifique-se de importar seu DatabaseHelper

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
  final TextEditingController _imagemController = TextEditingController();

  bool _isLoading = false; // Para indicar se está carregando

  // Função para cadastrar o produto no banco de dados
  Future<void> _cadastrarProduto() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Ativa o loading
      });

      try {
        // Criar o mapa de dados para salvar no banco de dados
        final newProduto = {
          DatabaseHelper.columnNomeProduto: _nomeController.text,
          DatabaseHelper.columnDescricaoProduto: _descricaoController.text,
          DatabaseHelper.columnValorProduto: double.parse(_valorController.text),
          DatabaseHelper.columnImagemProduto: _imagemController.text,  // URL ou caminho da imagem
          DatabaseHelper.columnConfeitariaIdProduto: widget.confeitariaId,  // Associando ao ID da confeitaria
        };

        // Inserir no banco de dados
        await DatabaseHelper.instance.insertProduto(newProduto);

        // Limpar campos após o cadastro
        _nomeController.clear();
        _descricaoController.clear();
        _valorController.clear();
        _imagemController.clear();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Produto cadastrado com sucesso!')));
        Navigator.pop(context);  // Voltar para a página anterior
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao cadastrar produto: $e')));
      } finally {
        setState(() {
          _isLoading = false; // Desativa o loading
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

              // Campo URL da Imagem
              TextFormField(
                controller: _imagemController,
                decoration: InputDecoration(labelText: 'URL da Imagem'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a URL da imagem';
                  }
                  // Pode adicionar uma validação de URL aqui, se necessário
                  return null;
                },
              ),

              SizedBox(height: 20),

              // Botão de Cadastro
              _isLoading
                  ? CircularProgressIndicator() // Indicador de carregamento
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
