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
      routes: {
        '/': (context) => const TelaLogin(),
        '/confeitarias': (context) =>  TelaListaConfeitarias(),
        '/detalhesConfeitaria': (context) => const TelaDetalhesConfeitaria(),
        '/loginConfeiteiro': (context) => const TelaLoginConfeiteiro(),
        '/gerenciarConfeitaria': (context) => const TelaGerenciarConfeitaria(),
        '/registroConfeiteiro': (context) => const TelaRegistroConfeiteiro(),  // Registro do confeiteiro
      },
    );
  }
}
