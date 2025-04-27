import 'package:desafio_confeit/banco/database_helper.dart';
import 'package:desafio_confeit/pages/editarproduto.dart';
import 'package:desafio_confeit/pages/gerenciamento.dart';
import 'package:desafio_confeit/pages/cadastroprodutos.dart';
import 'package:flutter/material.dart';

class DashboardConfeitariaPage extends StatefulWidget {
  final int confeitariaId;

  const DashboardConfeitariaPage({Key? key, required this.confeitariaId}) : super(key: key);

  @override
  _DashboardConfeitariaPageState createState() => _DashboardConfeitariaPageState();
}

class _DashboardConfeitariaPageState extends State<DashboardConfeitariaPage> {
  late Future<List<Map<String, dynamic>>> _produtos;

  @override
  void initState() {
    super.initState();
    _produtos = _getProdutos(widget.confeitariaId);
  }

  Future<List<Map<String, dynamic>>> _getProdutos(int confeitariaId) async {
    final dbHelper = DatabaseHelper.instance;
    List<Map<String, dynamic>> produtos = await dbHelper.getProdutos(confeitariaId);
    print("Produtos recuperados: $produtos");
    return produtos;
  }

  Future<void> _deleteProduto(int produtoId) async {
    final dbHelper = DatabaseHelper.instance;
    int result = await dbHelper.deleteProduto(produtoId);
    if (result > 0) {
      setState(() {
        _produtos = _getProdutos(widget.confeitariaId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard da Confeitaria'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _produtos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar produtos'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Nenhum produto cadastrado.'));
                  } else {
                    final produtos = snapshot.data!;
                    return ListView.builder(
                      itemCount: produtos.length,
                      itemBuilder: (context, index) {
                        final produto = produtos[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text(
                              produto['nome'],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Preço: R\$${produto['valor'].toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.pink),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditarProdutoPage(produto: produto),
                                      ),
                                    ).then((resultado) {
                                      if (resultado == true) {
                                        setState(() {});
                                      }
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _deleteProduto(produto['id']);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            // Botão para cadastrar produto
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CadastroProdutoPage(confeitariaId: widget.confeitariaId),
                    ),
                  ).then((_) {
                    setState(() {
                      _produtos = _getProdutos(widget.confeitariaId);
                    });
                  });

                },
                child: Text('Cadastrar Produto'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink, // Cor do botão
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
            // Botão para ir para a tela de gerenciamento da confeitaria
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  // Navegar para a tela de gerenciamento da confeitaria
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GerenciarConfeitariaPage(
                        confeitariaId: widget.confeitariaId,
                      ),
                    ),
                  );
                },
                child: Text('Gerenciar Confeitaria'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Cor do botão
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
