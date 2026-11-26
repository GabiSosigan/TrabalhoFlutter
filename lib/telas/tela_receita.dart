import 'package:flutter/material.dart';
import 'package:projetoaula/models/receita.dart';
import 'package:projetoaula/state/favoritos_controller.dart';
import 'package:projetoaula/tema.dart';
import 'package:projetoaula/widgets/imagem_receita.dart';

/// Detalhes da receita. Reaproveita o objeto completo vindo da listagem/pesquisa
/// (já contém ingredientes e instruções) e lê os favoritos do controller

class TelaReceita extends StatelessWidget {
  const TelaReceita({
    super.key,
    required this.receita,
    required this.favoritos,
  });

  final Receita receita;
  final FavoritosController favoritos;

  static Future<void> abrir(
      BuildContext context,
      Receita receita,
      FavoritosController favoritos,
      ) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TelaReceita(receita: receita, favoritos: favoritos),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      appBar: AppBar(
        backgroundColor: Cores.principalEscura,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Receita',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          ListenableBuilder(
            listenable: favoritos,
            builder: (context, _) {
              final favorito = favoritos.contem(receita.id);
              return IconButton(
                tooltip: favorito
                    ? 'Remover dos favoritos'
                    : 'Adicionar aos favoritos',
                icon: Icon(
                  favorito ? Icons.favorite : Icons.favorite_border,
                  color: favorito ? Colors.red : Colors.white,
                ),
                onPressed: () => favoritos.alternar(receita),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImagemReceita(
                url: receita.imagem,
                icone: iconeDaReceita(receita),
                largura: double.infinity,
                altura: 200,
                raio: 20,
                tamanhoIcone: 100,
                corIcone: Cores.textoSecundario.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 24),
              Text(
                receita.titulo,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Cores.principalEscura,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _subtitulo(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Cores.textoSecundario,
                ),
              ),
              if (receita.tiposRefeicao.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: receita.tiposRefeicao.map(_chip).toList(),
                ),
              ],
              const SizedBox(height: 24),
              _buildInfoCards(),
              const SizedBox(height: 32),
              const Text(
                'Ingredientes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Cores.principalEscura,
                ),
              ),
              const SizedBox(height: 12),
              if (receita.ingredientes.isEmpty)
                _textoVazio('Ingredientes não informados.')
              else
                ...receita.ingredientes.map(
                      (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 7),
                          child: CircleAvatar(
                            radius: 3,
                            backgroundColor: Cores.principalEscura,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Cores.principalEscura,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              const Text(
                'Modo de preparo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Cores.principalEscura,
                ),
              ),
              const SizedBox(height: 16),
              if (receita.passos.isEmpty)
                _textoVazio('Modo de preparo não informado.')
              else
                ...receita.passos.asMap().entries.map(
                      (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Cores.principalEscura,
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Cores.principalEscura,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _subtitulo() {
    final partes = <String>[
      if (receita.dificuldadeTexto != null) receita.dificuldadeTexto!,
      if (receita.culinaria != null) receita.culinaria!,
      receita.notaTexto,
    ];
    return partes.join(' • ');
  }

  Widget _buildInfoCards() {
    const naoInformado = 'Não informado';

    final cards = <Widget>[
      _InfoCard(
        titulo: receita.tempoTotal != null
            ? formatarMinutos(receita.tempoTotal!)
            : naoInformado,
        subtitulo: 'tempo total',
      ),
      if (receita.temPorcoes)
        _InfoCard(titulo: receita.porcoesTexto, subtitulo: 'porções'),
      _InfoCard(
        titulo: receita.tempoPreparo != null
            ? formatarMinutos(receita.tempoPreparo!)
            : naoInformado,
        subtitulo: 'preparo',
      ),
      _InfoCard(
        titulo: receita.tempoCozimento != null
            ? formatarMinutos(receita.tempoCozimento!)
            : naoInformado,
        subtitulo: 'cozimento',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final largura = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: cards
              .map((card) => SizedBox(width: largura, child: card))
              .toList(),
        );
      },
    );
  }

  Widget _chip(String texto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Cores.caixaClara,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: const TextStyle(fontSize: 12, color: Cores.principalEscura),
      ),
    );
  }

  Widget _textoVazio(String texto) {
    return Text(
      texto,
      style: const TextStyle(fontSize: 15, color: Cores.textoSecundario),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.titulo, required this.subtitulo});

  final String titulo;
  final String subtitulo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Cores.caixaClara,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Cores.principalEscura,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitulo,
            style: const TextStyle(fontSize: 12, color: Cores.textoSecundario),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}