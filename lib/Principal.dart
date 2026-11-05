import 'package:flutter/material.dart';
import 'package:projetoaula/Perfil.dart';

class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Perfil(),
    );
  }
}
