import 'package:desafio_confeit/banco/database_helper.dart';
import 'package:flutter/material.dart';

class TelaLoginConfeiteiro extends StatefulWidget {
  const TelaLoginConfeiteiro({super.key});

  @override
  State<TelaLoginConfeiteiro> createState() => _TelaLoginConfeiteiroState();
}

class _TelaLoginConfeiteiroState extends State<TelaLoginConfeiteiro> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  Future<void> _fazerLogin() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    // Buscar confeitaria no banco
    final confeitaria = await DatabaseHelper.instance.getConfeitariaByEmailSenha(email, senha);

    if (confeitaria != null) {
      final confeitariaId = confeitaria['id'];
      Navigator.pushNamed(context, '/dashboardConfeitaria', arguments: confeitariaId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail ou senha inválidos!')),
      );
    }
  }

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
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _senhaController,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _fazerLogin,
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
