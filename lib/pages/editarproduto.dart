import 'package:desafio_confeit/banco/database_helper.dart';
import 'package:flutter/material.dart'; // importa seu database helper

class EditarProdutoPage extends StatefulWidget {
  final Map<String, dynamic> produto;

  const EditarProdutoPage({Key? key, required this.produto}) : super(key: key);

  @override
  _EditarProdutoPageState createState() => _EditarProdutoPageState();
}

class _EditarProdutoPageState extends State<EditarProdutoPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  late TextEditingController _valorController;
  late TextEditingController _imagemController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.produto['nome']);
    _descricaoController = TextEditingController(text: widget.produto['descricao']);
    _valorController = TextEditingController(text: widget.produto['valor'].toString());
    _imagemController = TextEditingController(text: widget.produto['imagem']);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _valorController.dispose();
    _imagemController.dispose();
    super.dispose();
  }

  void _salvarEdicao() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> updatedProduto = {
        'id': widget.produto['id'],
        'nome': _nomeController.text,
        'descricao': _descricaoController.text,
        'valor': double.parse(_valorController.text),
        'imagem': _imagemController.text,
        'confeitariaId': widget.produto['confeitariaId'],
      };

      await DatabaseHelper.instance.updateProduto(updatedProduto);
      Navigator.pop(context, true); // volta pra tela anterior sinalizando sucesso
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Produto')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome do Produto'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
              ),
              TextFormField(
                controller: _valorController,
                decoration: InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Informe o valor' : null,
              ),
              TextFormField(
                controller: _imagemController,
                decoration: InputDecoration(labelText: 'URL da Imagem'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarEdicao,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
