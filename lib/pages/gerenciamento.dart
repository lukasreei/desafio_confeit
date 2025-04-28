import 'dart:io';
import 'package:desafio_confeit/banco/database_helper.dart';
import 'package:flutter/material.dart';

class GerenciarConfeitariaPage extends StatefulWidget {
  final int confeitariaId;

  GerenciarConfeitariaPage({required this.confeitariaId});

  @override
  _GerenciarConfeitariaPageState createState() =>
      _GerenciarConfeitariaPageState();
}

class _GerenciarConfeitariaPageState extends State<GerenciarConfeitariaPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _descricaoController;
  late TextEditingController _senhaController;

  Map<String, dynamic>? _confeitaria;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _emailController = TextEditingController();
    _descricaoController = TextEditingController();
    _senhaController = TextEditingController();
    _getConfeitaria();
  }

  // Função para carregar as informações da confeitaria
  Future<void> _getConfeitaria() async {
    try {
      var confeitaria = await DatabaseHelper.instance.getConfeitaria(widget.confeitariaId);
      if (confeitaria != null) {
        setState(() {
          _confeitaria = confeitaria;
          _nomeController.text = _confeitaria?['nome'] ?? '';
          _emailController.text = _confeitaria?['email'] ?? '';
          _descricaoController.text = _confeitaria?['descricao'] ?? '';
          _senhaController.text = _confeitaria?['senha'] ?? '';
        });
      } else {
        // Caso não encontre a confeitaria
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Confeitaria não encontrada'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print("Erro ao carregar confeitaria: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao carregar confeitaria: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  // Função para atualizar a confeitaria
  Future<void> _updateConfeitaria() async {
    if (_formKey.currentState!.validate()) {
      // Exibe um indicador de progresso
      showDialog(
        context: context,
        barrierDismissible: false, // Impede que o usuário feche o diálogo
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      try {
        // Atualizando os dados da confeitaria
        Map<String, dynamic> updatedData = {
          'id': widget.confeitariaId,
          'nome': _nomeController.text,
          'email': _emailController.text,
          'descricao': _descricaoController.text,
          'senha': _senhaController.text,
        };

        // Atualiza no banco de dados
        await DatabaseHelper.instance.updateConfeitaria(updatedData);

        // Fechar o diálogo de progresso
        Navigator.pop(context);

        // Exibe uma mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Confeitaria atualizada com sucesso!'),
          backgroundColor: Colors.green,
        ));

        // Opcional: volta para a tela anterior após a atualização
        Navigator.pop(context);
      } catch (e) {
        // Fechar o diálogo de progresso em caso de erro
        Navigator.pop(context);

        // Exibe uma mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro ao atualizar confeitaria: $e'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  // Função para excluir a confeitaria
  Future<void> _deleteConfeitaria() async {
    try {
      await DatabaseHelper.instance.deleteConfeitaria(widget.confeitariaId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Confeitaria excluída com sucesso!'),
        backgroundColor: Colors.red,
      ));
      Navigator.pop(context); // Volta para a tela anterior
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao excluir confeitaria: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Garantir que _confeitaria não seja null antes de acessar
    if (_confeitaria == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Gerenciar Confeitaria')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Verifica se a imagem existe no banco de dados
    String? imagePath = _confeitaria?['imagem'];

    return Scaffold(
      appBar: AppBar(title: Text('Gerenciar Confeitaria')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Exibe a imagem de forma segura
            imagePath != null && imagePath.isNotEmpty
                ? Image.file(
              File(imagePath),
              width: 100, // Define a largura da imagem
              height: 100, // Define a altura da imagem
              fit: BoxFit.cover, // Ajusta a imagem para cobrir o espaço
            )
                : Container(
              width: 100,
              height: 100,
              color: Colors.grey[200],
              child: Icon(Icons.image, color: Colors.grey),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nome é obrigatório';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email é obrigatório';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descricaoController,
              decoration: InputDecoration(labelText: 'Descrição'),
              maxLines: 2,
            ),
            TextFormField(
              controller: _senhaController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Senha é obrigatória';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateConfeitaria,
              child: Text('Atualizar'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _deleteConfeitaria,
              child: Text('Excluir Confeitaria'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
