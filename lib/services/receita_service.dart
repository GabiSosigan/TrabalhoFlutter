import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projetoaula/models/receita.dart';

enum TipoErro { rede, servidor, formato }

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

class ReceitaService {
  ReceitaService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _host = 'dummyjson.com';
  static const _timeout = Duration(seconds: 15);

  Future<List<Receita>> listar() {
    return _buscarLista(Uri.https(_host, '/recipes', {'limit': '0'}));
  }

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
        continue;
      }
    }

    if (lista.isNotEmpty && receitas.isEmpty) {
      throw const ReceitaException.formato();
    }

    /// Filtragem de receitas de cafeteria/padaria
    return receitas.where((r) => r.ehPadariaCafeteria).toList();
  }

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