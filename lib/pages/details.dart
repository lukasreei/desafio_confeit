import 'package:flutter/material.dart';
import 'package:desafio_confeit/banco/database_helper.dart'; // seu caminho correto aqui
import 'dart:io'; // Importa para trabalhar com File

class TelaDetalhesConfeitaria extends StatefulWidget {
  final Map<String, dynamic> confeitaria;

  const TelaDetalhesConfeitaria({Key? key, required this.confeitaria}) : super(key: key);

  @override
  _TelaDetalhesConfeitariaState createState() => _TelaDetalhesConfeitariaState();
}

class _TelaDetalhesConfeitariaState extends State<TelaDetalhesConfeitaria> {
  List<Map<String, dynamic>> produtos = [];

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    final lista = await DatabaseHelper.instance.getProdutos(widget.confeitaria['id']);
    setState(() {
      produtos = lista;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.confeitaria['nome']),
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.confeitaria['imagem'] != null && widget.confeitaria['imagem'].isNotEmpty)
              Image.file(
                File(widget.confeitaria['imagem']), // Exibe a imagem localmente
                fit: BoxFit.cover,
              )
            else
              Container(height: 200, color: Colors.grey), // Caso não tenha imagem
            const SizedBox(height: 16),
            Text(
              'Avaliação: ${widget.confeitaria['avaliacao']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Endereço: ${widget.confeitaria['rua']}, ${widget.confeitaria['numero']} - ${widget.confeitaria['bairro']}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              '${widget.confeitaria['cidade']} - ${widget.confeitaria['estado']} - CEP: ${widget.confeitaria['cep']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Descrição: ${widget.confeitaria['descricao']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Produtos Disponíveis:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            produtos.isNotEmpty
                ? ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: produto['imagem'] != null
                        ? Image.file(
                      File(produto['imagem']), // Exibe a imagem localmente
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                        : const Icon(Icons.image_not_supported),
                    title: Text(produto['nome']),
                    subtitle: Text('R\$ ${produto['valor'].toStringAsFixed(2)}'),
                  ),
                );
              },
            )
                : const Text('Nenhum produto cadastrado ainda.'),
          ],
        ),
      ),
    );
  }
}
