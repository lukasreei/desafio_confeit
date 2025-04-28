import 'package:desafio_confeit/banco/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io'; // Importa para trabalhar com File

class TelaListarConfeitarias extends StatefulWidget {
  @override
  _TelaListarConfeitariasState createState() => _TelaListarConfeitariasState();
}

class _TelaListarConfeitariasState extends State<TelaListarConfeitarias> {
  List<Map<String, dynamic>> confeitarias = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConfeitarias();
  }

  // Carregar confeitarias do banco de dados
  Future<void> _loadConfeitarias() async {
    final data = await DatabaseHelper().getConfeitarias();
    setState(() {
      confeitarias = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Confeitarias mais bem avaliadas (top 3)
    final topConfeitarias = confeitarias.isNotEmpty
        ? confeitarias.sublist(0, confeitarias.length > 3 ? 3 : confeitarias.length)
        : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confeitarias'),
        backgroundColor: Colors.pink,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            // Carrossel com as confeitarias mais bem avaliadas
            if (topConfeitarias.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CarouselSlider.builder(
                  itemCount: topConfeitarias.length,
                  itemBuilder: (context, index, realIndex) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                        image: DecorationImage(
                          image: FileImage(File(topConfeitarias[index]['imagem'])),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            topConfeitarias[index]['nome'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 2.0,
                    viewportFraction: 0.8,
                    height: 250,
                    enableInfiniteScroll: false, // Para evitar looping infinito
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // Lista com todas as confeitarias
            if (confeitarias.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: confeitarias.map((confeitaria) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4, // Adicionando sombra ao cartão
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(
                            File(confeitaria['imagem']), // Exibe a imagem localmente
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          confeitaria['nome'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Avaliação: ${confeitaria['avaliacao']}',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        onTap: () {
                          // Ação quando clicar na confeitaria, como exibir detalhes
                          Navigator.pushNamed(
                            context,
                            '/detalhesConfeitaria',
                            arguments: confeitaria,
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            if (confeitarias.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Nenhuma confeitaria encontrada.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
