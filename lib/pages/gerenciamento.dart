import 'package:flutter/material.dart';

class TelaGerenciarConfeitaria extends StatelessWidget {
  const TelaGerenciarConfeitaria({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Confeitaria'),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Redirecionar para a tela de cadastro de produtos ou outras opções
          },
          child: const Text('Cadastrar Produto'),
        ),
      ),
    );
  }
}
