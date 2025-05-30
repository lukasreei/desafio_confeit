import 'package:desafio_confeit/banco/database_helper.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

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
  File? _imagem;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.produto['nome']);
    _descricaoController = TextEditingController(text: widget.produto['descricao']);
    _valorController = TextEditingController(text: widget.produto['valor'].toString());
    _imagemController = TextEditingController(text: widget.produto['imagem']);
    _imagem = File(widget.produto['imagem']);
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
        'imagem': _imagem?.path ?? '',
        'confeitariaId': widget.produto['confeitariaId'],
      };

      await DatabaseHelper.instance.updateProduto(updatedProduto);
      Navigator.pop(context, true);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagem = File(pickedFile.path);
        _imagemController.text = _imagem!.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Produto')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _imagem != null
                ? Image.file(
              _imagem!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            )
                : Center(child: Text('Sem imagem disponível')),

            Card(
              margin: EdgeInsets.only(bottom: 16.0),
              child: ListTile(
                title: Text(widget.produto['nome']),
                subtitle: Text(widget.produto['descricao']),
                trailing: Text('R\$ ${widget.produto['valor'].toString()}'),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(labelText: 'Nome do Produto',border: OutlineInputBorder()),
                    validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
                  ),
                  SizedBox(height: 12,),
                  TextFormField(
                    controller: _descricaoController,
                    decoration: InputDecoration(labelText: 'Descrição',border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 12,),
                  TextFormField(
                    controller: _valorController,
                    decoration: InputDecoration(labelText: 'Valor',border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty ? 'Informe o valor' : null,
                  ),
                  SizedBox(height: 12,),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Selecionar Imagem'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _salvarEdicao,
                    child: Text('Salvar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
