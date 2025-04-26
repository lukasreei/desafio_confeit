import 'package:flutter/material.dart';

class TelaLoginConfeiteiro extends StatelessWidget {
  const TelaLoginConfeiteiro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Confeiteiro'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Entre com suas credenciais',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            TextField(
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navegar para a tela de gerenciar confeitaria
                Navigator.pushNamed(context, '/gerenciarConfeitaria');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Entrar',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Navegar para a tela de registro de confeiteiro
                Navigator.pushNamed(context, '/registroConfeiteiro');
              },
              child: const Text(
                'Não tem conta? Registre-se',
                style: TextStyle(fontSize: 16, color: Colors.pink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
