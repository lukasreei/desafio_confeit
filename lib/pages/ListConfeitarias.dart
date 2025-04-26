import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TelaListaConfeitarias extends StatelessWidget {
  final List<Map<String, String>> confeitarias = [
    {
      'nome': 'Confeitaria Doce Sabor',
      'avaliacao': '4.8',
      'imagem': 'https://via.placeholder.com/300x200.png?text=Confeitaria+1',
    },
    {
      'nome': 'Doces da Vovó',
      'avaliacao': '4.9',
      'imagem': 'https://via.placeholder.com/300x200.png?text=Confeitaria+2',
    },
    {
      'nome': 'Chocolates & Cia',
      'avaliacao': '4.7',
      'imagem': 'https://via.placeholder.com/300x200.png?text=Confeitaria+3',
    },
    {
      'nome': 'Delícias de Maria',
      'avaliacao': '4.6',
      'imagem': 'https://via.placeholder.com/300x200.png?text=Confeitaria+4',
    },
  ];

  @override
  Widget build(BuildContext context) {

    final topConfeitarias = confeitarias.sublist(0, 3);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confeitarias'),
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carrossel com as confeitarias mais bem avaliadas
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CarouselSlider.builder(
                itemCount: topConfeitarias.length,
                itemBuilder: (context, index, realIndex) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(topConfeitarias[index]['imagem']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          topConfeitarias[index]['nome']!,
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
                ),
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: confeitarias.map((confeitaria) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(confeitaria['imagem']!),
                      ),
                      title: Text(confeitaria['nome']!),
                      subtitle: Text('Avaliação: ${confeitaria['avaliacao']}'),
                      onTap: () {
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
