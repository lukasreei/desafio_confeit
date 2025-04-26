import 'package:desafio_confeit/pages/ListConfeitarias.dart';
import 'package:desafio_confeit/pages/LoginCadastroConfeiteiro.dart';
import 'package:desafio_confeit/pages/RegistroConfeiteiro.dart';
import 'package:desafio_confeit/pages/details.dart';
import 'package:desafio_confeit/pages/gerenciamento.dart';
import 'package:desafio_confeit/pages/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DoceMapaApp());
}

class DoceMapaApp extends StatelessWidget {
  const DoceMapaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoceMapa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const TelaLogin());
          case '/confeitarias':
            return MaterialPageRoute(builder: (_) => TelaListarConfeitarias());
          case '/detalhesConfeitaria':
            return MaterialPageRoute(builder: (_) => const TelaDetalhesConfeitaria());
          case '/loginConfeiteiro':
            return MaterialPageRoute(builder: (_) => const TelaLoginConfeiteiro());
          case '/registroConfeiteiro':
            return MaterialPageRoute(builder: (_) => CadastroConfeitariaPage());
          case '/gerenciarConfeitaria':
            final confeitariaId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (_) => CadastroProdutoPage(confeitariaId: confeitariaId),
            );
          default:
            return null; // Se a rota não existir
        }
      },
    );
  }
}
