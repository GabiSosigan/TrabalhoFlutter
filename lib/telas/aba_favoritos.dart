import 'package:flutter/material.dart';
import 'package:projetoaula/state/favoritos_controller.dart';
import 'package:projetoaula/telas/tela_receita.dart';
import 'package:projetoaula/tema.dart';
import 'package:projetoaula/widgets/estado_mensagem.dart';
import 'package:projetoaula/widgets/receita_card.dart';

class AbaFavoritos extends StatelessWidget {
  const AbaFavoritos({super.key, required this.favoritos});

  final FavoritosController favoritos;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: favoritos,
      builder: (context, _) {
        final receitas = favoritos.itens;

        return ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            const Text(
              'Meus Favoritos',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Cores.principalEscura,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Suas receitas salvas para acessar rápido.',
              style: TextStyle(fontSize: 14, color: Cores.textoSecundario),
            ),
            const SizedBox(height: 24),
            if (receitas.isEmpty)
              const EstadoMensagem(
                icone: Icons.heart_broken,
                titulo: 'Você ainda não favoritou\nnenhuma receita.',
                detalhe: 'Toque no coração de uma receita para salvá-la aqui.',
                paddingVertical: 30,
              )
            else
              ...receitas.map(
                    (receita) => ReceitaCard(
                  key: ValueKey(receita.id),
                  receita: receita,
                  favoritos: favoritos,
                  onTap: () =>
                      TelaReceita.abrir(context, receita, favoritos),
                ),
              ),
          ],
        );
      },
    );
  }
}