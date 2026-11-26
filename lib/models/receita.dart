/// Receita retornada pela API DummyJSON.
///
/// O parsing é defensivo: campos ausentes ou com tipo inesperado viram
/// `null` (ou lista vazia) em vez de quebrar o app. Somente o `id` é
/// obrigatório, pois é a identidade da receita (seleção e favoritos).
class Receita {
  const Receita({
    required this.id,
    this.nome,
    this.ingredientes = const [],
    this.passos = const [],
    this.imagem,
    this.tempoPreparo,
    this.tempoCozimento,
    this.porcoes,
    this.nota,
    this.tiposRefeicao = const [],
    this.tags = const [],
    this.dificuldade,
    this.culinaria,
  });

  final int id;
  final String? nome;
  final List<String> ingredientes;
  final List<String> passos;
  final String? imagem;

  /// `num` porque a API pode mandar int ou double.
  final num? tempoPreparo;
  final num? tempoCozimento;
  final num? porcoes;
  final num? nota;

  /// `mealType` é uma lista (ex.: ["Dinner", "Lunch"]), nunca uma String única.
  final List<String> tiposRefeicao;

  /// Etiquetas da API (ex.: ["Cookies", "Dessert", "Baking"]).
  final List<String> tags;
  final String? dificuldade;
  final String? culinaria;

  factory Receita.fromJson(Map<String, dynamic> json) {
    final id = _paraInt(json['id']);
    if (id == null) {
      throw const FormatException('Receita sem id válido.');
    }
    return Receita(
      id: id,
      nome: _paraTexto(json['name']),
      ingredientes: _paraListaTexto(json['ingredients']),
      passos: _paraListaTexto(json['instructions']),
      imagem: _paraTexto(json['image']),
      tempoPreparo: _paraNumero(json['prepTimeMinutes']),
      tempoCozimento: _paraNumero(json['cookTimeMinutes']),
      porcoes: _paraNumero(json['servings']),
      nota: _paraNumero(json['rating']),
      tiposRefeicao: _paraListaTexto(json['mealType']),
      tags: _paraListaTexto(json['tags']),
      dificuldade: _paraTexto(json['difficulty']),
      culinaria: _paraTexto(json['cuisine']),
    );
  }

  // ---------------------------------------------------------------------------
  // Valores prontos para exibição
  // ---------------------------------------------------------------------------

  /// Nome para exibir; trata ausência e texto vazio.
  String get titulo => nome ?? 'Receita sem nome';

  /// Tags que, mesmo sem ser sobremesa ou bebida, combinam com padaria
  /// (pão e massas). Remova ou acrescente itens para ajustar o cardápio.
  static const _tagsDePadaria = {'baking', 'bruschetta', 'spanakopita'};

  /// Define se a receita combina com o tema do app (padaria e cafeteria):
  /// sobremesas, bebidas (exceto drinks alcoólicos) e itens de forno/pães.
  bool get ehPadariaCafeteria {
    final tipos = tiposRefeicao.map((t) => t.toLowerCase()).toSet();
    final etiquetas = tags.map((t) => t.toLowerCase()).toSet();

    if (etiquetas.contains('cocktail')) return false;

    return tipos.contains('dessert') ||
        tipos.contains('beverage') ||
        etiquetas.any(_tagsDePadaria.contains);
  }

  /// O total só existe se AMBOS os tempos foram informados.
  /// Ausência nunca é tratada como zero.
  num? get tempoTotal {
    final preparo = tempoPreparo;
    final cozimento = tempoCozimento;
    if (preparo == null || cozimento == null) return null;
    return preparo + cozimento;
  }

  /// Resumo curto de tempo para os cards da listagem.
  String get resumoTempo {
    final total = tempoTotal;
    if (total != null) return formatarMinutos(total);
    final preparo = tempoPreparo;
    if (preparo != null) return 'Preparo ${formatarMinutos(preparo)}';
    final cozimento = tempoCozimento;
    if (cozimento != null) return 'Cozimento ${formatarMinutos(cozimento)}';
    return 'Tempo não informado';
  }

  /// Ex.: "4.7 / 5". Sem nota, indica a ausência.
  String get notaTexto {
    final valor = nota;
    if (valor == null) return 'Sem avaliação';
    return '${valor.toDouble().toStringAsFixed(1)} / 5';
  }

  /// Porções só são exibidas quando o valor é utilizável (> 0).
  bool get temPorcoes {
    final valor = porcoes;
    return valor != null && valor > 0;
  }

  String get porcoesTexto {
    final valor = porcoes;
    if (valor == null) return '';
    return valor == valor.truncate() ? '${valor.toInt()}' : '$valor';
  }

  /// Traduz só a dificuldade (para combinar com o visual original);
  /// qualquer outro valor é exibido como veio da API.
  String? get dificuldadeTexto {
    switch (dificuldade?.toLowerCase()) {
      case 'easy':
        return 'Fácil';
      case 'medium':
        return 'Médio';
      case 'hard':
        return 'Difícil';
      default:
        return dificuldade;
    }
  }
}

/// Ex.: 45 -> "45 min", 80 -> "1h 20 min", 120 -> "2h".
String formatarMinutos(num minutos) {
  final total = minutos.round();
  if (total < 60) return '$total min';
  final horas = total ~/ 60;
  final resto = total % 60;
  return resto == 0 ? '${horas}h' : '${horas}h $resto min';
}

// -----------------------------------------------------------------------------
// Conversões seguras
// -----------------------------------------------------------------------------

int? _paraInt(dynamic valor) {
  if (valor is int) return valor;
  if (valor is num && valor.isFinite && valor == valor.truncate()) {
    return valor.toInt();
  }
  if (valor is String) return int.tryParse(valor.trim());
  return null;
}

num? _paraNumero(dynamic valor) {
  num? resultado;
  if (valor is num) {
    resultado = valor;
  } else if (valor is String) {
    resultado = num.tryParse(valor.trim());
  }
  if (resultado == null || !resultado.isFinite || resultado < 0) return null;
  return resultado;
}

String? _paraTexto(dynamic valor) {
  if (valor is! String) return null;
  final texto = valor.trim();
  return texto.isEmpty ? null : texto;
}

List<String> _paraListaTexto(dynamic valor) {
  if (valor is List) {
    return valor
        .map((item) => item?.toString().trim() ?? '')
        .where((texto) => texto.isNotEmpty)
        .toList();
  }
  if (valor is String && valor.trim().isNotEmpty) return [valor.trim()];
  return const [];
}