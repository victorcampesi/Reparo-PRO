import 'package:flutter/foundation.dart';

class PreferenciasController extends ChangeNotifier {
  PreferenciasController._();

  static final PreferenciasController instance = PreferenciasController._();

  final Set<String> _areas = {};

  Set<String> get areas => Set.unmodifiable(_areas);
  bool get temAreas => _areas.isNotEmpty;

  void definir(Set<String> novas) {
    _areas
      ..clear()
      ..addAll(novas);
    notifyListeners();
  }

  void limpar() {
    _areas.clear();
    notifyListeners();
  }
}