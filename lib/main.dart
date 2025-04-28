import 'package:desafio_confeit/pages/ListConfeitarias.dart';
import 'package:desafio_confeit/pages/LoginCadastroConfeiteiro.dart';
import 'package:desafio_confeit/pages/RegistroConfeiteiro.dart';
import 'package:desafio_confeit/pages/details.dart';
import 'package:desafio_confeit/pages/cadastroprodutos.dart';
import 'package:desafio_confeit/pages/login.dart';
import 'package:desafio_confeit/pages/DashboardConfeitariaPage.dart'; // Importar a nova tela de dashboard
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
            final confeitaria = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => TelaDetalhesConfeitaria(confeitaria: confeitaria),
            );
          case '/loginConfeiteiro':
            return MaterialPageRoute(builder: (_) => const TelaLoginConfeiteiro());
          case '/registroConfeiteiro':
            return MaterialPageRoute(builder: (_) => CadastroConfeitariaPage());
          case '/gerenciarConfeitaria':
            final confeitariaId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (_) => CadastroProdutoPage(confeitariaId: confeitariaId),
            );
          case '/dashboardConfeitaria': // Nova rota para o dashboard
            final confeitariaId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (_) => DashboardConfeitariaPage(confeitariaId: confeitariaId),
            );
          default:
            return null;
        }
      },
    );
  }
}
