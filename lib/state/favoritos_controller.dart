import 'package:flutter/foundation.dart';
import 'package:projetoaula/models/receita.dart';

class FavoritosController extends ChangeNotifier {
  final Map<int, Receita> _itens = {};

  List<Receita> get itens => List.unmodifiable(_itens.values);

  bool contem(int id) => _itens.containsKey(id);

  void alternar(Receita receita) {
    if (_itens.remove(receita.id) == null) {
      _itens[receita.id] = receita;
    }
    notifyListeners();
  }
}