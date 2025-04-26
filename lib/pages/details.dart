import 'package:flutter/material.dart';

class TelaDetalhesConfeitaria extends StatelessWidget {
  const TelaDetalhesConfeitaria({super.key});

  @override
  Widget build(BuildContext context) {
    final String confeitariaNome = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da $confeitariaNome'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detalhes da $confeitariaNome',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Aqui você pode ver todos os produtos dessa confeitaria e realizar pedidos.',
              style: TextStyle(fontSize: 18),
            ),
            // Adicione widgets para exibir os produtos aqui
          ],
        ),
      ),
    );
  }
}
