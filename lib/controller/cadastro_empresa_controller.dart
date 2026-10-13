import 'package:flutter/foundation.dart';

class CadastroEmpresaController extends ChangeNotifier  {
  String nome = '';
  String cnpj = '';
  String email = '';
  String senha = '';
  String telefone = '';

  String cidade = '';
  String funcionarios = '';
  String tempoResposta = '';
  String link = '';
  String descricao = '';
  double raioKm = 20;
  bool atende24h = false;
  bool orcamentoGratis = true;
  Set<String> areas = {};
  Set<String> publicos = {};

  static final RegExp _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  static const List<int> _pesos1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
  static const List<int> _pesos2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

  void salvar({
  required String nome,
  required String cnpj,
  required String email,
  required String telefone,
  required String senha,
}) {
  this.nome = nome.trim();
  this.cnpj = cnpj.replaceAll(RegExp(r'\D'), '');
  this.email = email.trim();
  this.telefone = telefone.replaceAll(RegExp(r'\D'), '');
  this.senha = senha;
}

  void salvarPerfil({
    required String cidade,
    required String funcionarios,
    required String tempoResposta,
    required String link,
    required String descricao,
    required double raioKm,
    required bool atende24h,
    required bool orcamentoGratis,
    required Set<String> areas,
    required Set<String> publicos,
  }) {
    this.cidade = cidade.trim();
    this.funcionarios = funcionarios;
    this.tempoResposta = tempoResposta;
    this.link = link.trim();
    this.descricao = descricao.trim();
    this.raioKm = raioKm;
    this.atende24h = atende24h;
    this.orcamentoGratis = orcamentoGratis;
    this.areas = Set.of(areas);
    this.publicos = Set.of(publicos);
  }

  void atualizarPerfil({
    required String nome,
    required String email,
    required String telefone,
  required String cidade,
    required String link,
    required String descricao,
  }) {
    this.nome = nome.trim();
    this.email = email.trim();
    this.telefone = telefone.replaceAll(RegExp(r'\D'), '');
    this.cidade = cidade.trim();
    this.link = link.trim();
    this.descricao = descricao.trim();
    notifyListeners();
  }

  void limpar() {
    nome = '';
    cnpj = '';
    email = '';
    senha = '';
    cidade = '';
    telefone = '';
    funcionarios = '';
    tempoResposta = '';
    link = '';
    descricao = '';
    raioKm = 20;
    atende24h = false;
    orcamentoGratis = true;
    areas = {};
    publicos = {};
  }

  String get telefoneFormatado {
    final t = telefone;
    if (t.length == 11) {
      return '(${t.substring(0, 2)}) ${t.substring(2, 7)}-${t.substring(7)}';
    }
    if (t.length == 10) {
      return '(${t.substring(0, 2)}) ${t.substring(2, 6)}-${t.substring(6)}';
    }
    return t;
  }

  bool isValidTelefone(String telefone) {
    final d = telefone.replaceAll(RegExp(r'\D'), '');
    if (d.length != 10 && d.length != 11) return false;
    if (d.startsWith('0') || d[1] == '0') return false; // DDD inválido
    if (d.length == 11 && d[2] != '9') return false; // celular começa com 9
    return true;
  }

  String get cnpjFormatado {
    if (cnpj.length != 14) return cnpj;
    return '${cnpj.substring(0, 2)}.${cnpj.substring(2, 5)}.'
        '${cnpj.substring(5, 8)}/${cnpj.substring(8, 12)}-${cnpj.substring(12)}';
  }

  bool isValidEmail(String email) => _emailRegex.hasMatch(email.trim());

  bool senhasIguais(String senha, String confirmacao) => senha == confirmacao;

  bool isValidCnpj(String cnpj) {
    final digits = cnpj.replaceAll(RegExp(r'\D'), '');

    if (digits.length != 14) return false;

    if (RegExp(r'^(\d)\1{13}$').hasMatch(digits)) return false;

    final nums = digits.split('').map(int.parse).toList();

    return _digitoVerificador(nums, _pesos1) == nums[12] &&
        _digitoVerificador(nums, _pesos2) == nums[13];
  }

  int _digitoVerificador(List<int> nums, List<int> pesos) {
    int soma = 0;
    for (int i = 0; i < pesos.length; i++) {
      soma += nums[i] * pesos[i];
    }
    final resto = soma % 11;
    return resto < 2 ? 0 : 11 - resto;
  }
}