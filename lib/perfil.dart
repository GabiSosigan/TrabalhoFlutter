import 'package:flutter/material.dart';
import 'package:projetoaula/services/receita_service.dart';
import 'package:projetoaula/state/favoritos_controller.dart';
import 'package:projetoaula/telas/aba_explorar.dart';
import 'package:projetoaula/telas/aba_favoritos.dart';
import 'package:projetoaula/tema.dart';

/// Tela principal: identidade do app + acesso à listagem/pesquisa (Explorar)
/// e aos favoritos. Aqui ficam as duas instâncias compartilhadas pelas telas:
/// o serviço da API e o controller de favoritos (fonte única de verdade).
class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final ReceitaService _service = ReceitaService();
  final FavoritosController _favoritos = FavoritosController();

  int _currentIndex = 0;

  @override
  void dispose() {
    _favoritos.dispose();
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      appBar: AppBar(
        backgroundColor: Cores.principalEscura,
        toolbarHeight: 85,
        elevation: 0,
        shape: const RoundedRectangleBorder(),
        title: Row(
          children: const [
            Text(
              'Bake & Brew',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'fantasy',
              ),
            ),
            SizedBox(width: 12),
            Icon(Icons.coffee, color: Colors.white, size: 28),
          ],
        ),
      ),
      // IndexedStack mantém as duas abas vivas: trocar de aba não perde a
      // pesquisa nem a rolagem, e não dispara nova requisição.
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            AbaExplorar(service: _service, favoritos: _favoritos),
            AbaFavoritos(favoritos: _favoritos),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Cores.fundo,
        selectedItemColor: Cores.principalEscura,
        unselectedItemColor: Cores.textoSecundario,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explorar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}