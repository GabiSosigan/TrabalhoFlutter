import 'package:flutter/material.dart';
import 'package:projetoaula/tema.dart';

/// Usada para erro de rede/servidor/formato, busca sem resultados e
/// favoritos vazios, cada um com ícone e texto próprios.

class EstadoMensagem extends StatelessWidget {
  const EstadoMensagem({
    super.key,
    required this.icone,
    required this.titulo,
    this.detalhe,
    this.rotuloAcao,
    this.onAcao,
    this.paddingVertical = 40,
  });

  final IconData icone;
  final String titulo;
  final String? detalhe;
  final String? rotuloAcao;
  final VoidCallback? onAcao;
  final double paddingVertical;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: paddingVertical),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 60, color: Cores.bordaIcone),
            const SizedBox(height: 16),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Cores.principalEscura,
              ),
            ),
            if (detalhe != null) ...[
              const SizedBox(height: 8),
              Text(
                detalhe!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Cores.textoSecundario,
                ),
              ),
            ],
            if (rotuloAcao != null) ...[
              const SizedBox(height: 20),
              SizedBox(
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: onAcao,
                  icon: const Icon(Icons.refresh),
                  label: Text(
                    rotuloAcao!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Cores.principalEscura,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}