import 'package:flutter/material.dart';
import 'package:projetoaula/models/receita.dart';
import 'package:projetoaula/tema.dart';

/// Ícone alternativo conforme o tipo de refeição (caso a imagem não carregue)

IconData iconeDaReceita(Receita receita) {
  final tipos = receita.tiposRefeicao.map((t) => t.toLowerCase()).toList();
  if (tipos.contains('beverage')) return Icons.coffee;
  if (tipos.contains('dessert')) return Icons.cake;
  if (tipos.contains('snack') || tipos.contains('breakfast')) {
    return Icons.bakery_dining;
  }
  return Icons.restaurant;
}

/// Mostra a imagem da receita.

class ImagemReceita extends StatelessWidget {
  const ImagemReceita({
    super.key,
    required this.url,
    required this.icone,
    this.largura,
    this.altura,
    this.raio = 12,
    this.tamanhoIcone = 40,
    this.corIcone = Cores.textoSecundario,
  });

  final String? url;
  final IconData icone;
  final double? largura;
  final double? altura;
  final double raio;
  final double tamanhoIcone;
  final Color corIcone;

  @override
  Widget build(BuildContext context) {
    final endereco = url;
    final temUrl = endereco != null && endereco.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(raio),
      child: SizedBox(
        width: largura,
        height: altura,
        child: temUrl
            ? Image.network(
          endereco,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progresso) {
            if (progresso == null) return child;
            return _caixa(
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Cores.textoSecundario,
                ),
              ),
            );
          },
          errorBuilder: (context, erro, pilha) =>
              _caixa(Icon(icone, size: tamanhoIcone, color: corIcone)),
        )
            : _caixa(Icon(icone, size: tamanhoIcone, color: corIcone)),
      ),
    );
  }

  Widget _caixa(Widget filho) {
    return Container(color: Cores.caixaClara, child: Center(child: filho));
  }
}