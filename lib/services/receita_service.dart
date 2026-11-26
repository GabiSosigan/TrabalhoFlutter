import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projetoaula/models/receita.dart';

enum TipoErro { rede, servidor, formato }

/// Único tipo de erro que a interface precisa tratar.
class ReceitaException implements Exception {
  const ReceitaException._(this.tipo, this.mensagem, [this.statusCode]);

  const ReceitaException.rede()
      : this._(
    TipoErro.rede,
    'Não foi possível conectar. Verifique sua internet e tente novamente.',
  );

  const ReceitaException.servidor(int status)
      : this._(
    TipoErro.servidor,
    'O servidor respondeu com um erro (código $status). Tente novamente em instantes.',
    status,
  );

  const ReceitaException.formato()
      : this._(
    TipoErro.formato,
    'Recebemos uma resposta inesperada do servidor. Tente novamente.',
  );

  final TipoErro tipo;
  final String mensagem;
  final int? statusCode;

  @override
  String toString() => 'ReceitaException($tipo, $statusCode)';
}

/// Acesso à API https://dummyjson.com/docs/recipes
///
/// Detalhe da receita: a listagem e a pesquisa já devolvem o objeto completo
/// (ingredientes e instruções), então a tela de detalhes reaproveita esse
/// objeto em vez de chamar /recipes/{id} de novo.
class ReceitaService {
  ReceitaService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _host = 'dummyjson.com';
  static const _timeout = Duration(seconds: 15);

  /// Busca os endpoints de uma categoria (ex.: /recipes/meal-type/dessert,
  /// /recipes/tag/Baking, /recipes) e junta tudo sem duplicatas, pelo `id`.
  /// `limit=0` traz todos os itens, sem paginar.
  /// GET /recipes?limit=0 (traz todas as receitas e filtra por padaria/cafeteria).
  Future<List<Receita>> listar() {
    return _buscarLista(Uri.https(_host, '/recipes', {'limit': '0'}));
  }

  /// GET /recipes/search?q=termo (Uri.https já codifica o termo).
  Future<List<Receita>> pesquisar(String termo) {
    return _buscarLista(
      Uri.https(_host, '/recipes/search', {'q': termo.trim(), 'limit': '0'}),
    );
  }

  Future<List<Receita>> _buscarLista(Uri uri) async {
    final corpo = await _get(uri);

    if (corpo is! Map<String, dynamic>) throw const ReceitaException.formato();
    final lista = corpo['recipes'];
    if (lista is! List) throw const ReceitaException.formato();

    final receitas = <Receita>[];
    for (final item in lista) {
      if (item is! Map<String, dynamic>) continue;
      try {
        receitas.add(Receita.fromJson(item));
      } on FormatException {
        continue; // ignora só o item inválido
      }
    }

    // Veio conteúdo, mas nada aproveitável: corpo incompatível.
    if (lista.isNotEmpty && receitas.isEmpty) {
      throw const ReceitaException.formato();
    }

    // O app é de padaria/cafeteria: a API não tem esse filtro, então ele é
    // aplicado aqui, tanto na listagem quanto na pesquisa.
    return receitas.where((r) => r.ehPadariaCafeteria).toList();
  }

  /// GET assíncrono + validação de status + decodificação do JSON.
  Future<dynamic> _get(Uri uri) async {
    final http.Response resposta;
    try {
      resposta = await _client.get(uri).timeout(_timeout);
    } on TimeoutException {
      throw const ReceitaException.rede();
    } catch (_) {
      throw const ReceitaException.rede();
    }

    if (resposta.statusCode != 200) {
      throw ReceitaException.servidor(resposta.statusCode);
    }

    try {
      return jsonDecode(utf8.decode(resposta.bodyBytes));
    } on FormatException {
      throw const ReceitaException.formato();
    }
  }

  void dispose() => _client.close();
}