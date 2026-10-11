import 'package:flutter/foundation.dart';

enum TipoConta { consumidor, autonomo, empresa }

class SessaoController extends ChangeNotifier {
  SessaoController._();

  static final SessaoController instance = SessaoController._();

  TipoConta? _tipoConta;

  TipoConta? get tipoConta => _tipoConta;

  bool get ehConsumidor => _tipoConta == TipoConta.consumidor;
  bool get ehPrestador =>
      _tipoConta == TipoConta.autonomo || _tipoConta == TipoConta.empresa;

  void definirTipoConta(TipoConta tipo) {
    _tipoConta = tipo;
    notifyListeners();
  }

  void limpar() {
    _tipoConta = null;
    notifyListeners();
  }
}