import 'package:flutter/material.dart';
import 'package:projetoaula/models/receita.dart';
import 'package:projetoaula/state/favoritos_controller.dart';
import 'package:projetoaula/tema.dart';
import 'package:projetoaula/widgets/imagem_receita.dart';

class ReceitaCard extends StatelessWidget {
  const ReceitaCard({
    super.key,
    required this.receita,
    required this.favoritos,
    required this.onTap,
  });

  final Receita receita;
  final FavoritosController favoritos;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final forma = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: Cores.bordaIcone),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Material(
        color: Colors.white,
        shape: forma,
        child: InkWell(
          customBorder: forma,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ImagemReceita(
                  url: receita.imagem,
                  icone: iconeDaReceita(receita),
                  largura: 80,
                  altura: 80,
                  raio: 12,
                  tamanhoIcone: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        receita.titulo,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Cores.principalEscura,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _subtitulo(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Cores.textoSecundario,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              receita.notaTexto,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Cores.principalEscura,
                              ),
                            ),
                          ),
                          ListenableBuilder(
                            listenable: favoritos,
                            builder: (context, _) {
                              final favorito = favoritos.contem(receita.id);
                              return IconButton(
                                tooltip: favorito
                                    ? 'Remover dos favoritos'
                                    : 'Adicionar aos favoritos',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 36,
                                  minHeight: 36,
                                ),
                                iconSize: 24,
                                onPressed: () => favoritos.alternar(receita),
                                icon: Icon(
                                  favorito
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: favorito
                                      ? Colors.red
                                      : Cores.principalEscura,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  String _subtitulo() {
    final dificuldade = receita.dificuldadeTexto;
    return dificuldade == null
        ? receita.resumoTempo
        : '${receita.resumoTempo} • $dificuldade';
  }
}