import 'package:flutter/foundation.dart';

class CadastroUsuarioController extends ChangeNotifier {
  String nome = '';
  String cpf = '';
  String email = '';
  String telefone = '';
  String senha = '';
  String cidade = '';
  String formacao = '';
  String experiencia = '';
  String descricao = '';
  String portfolio = '';
  Set<String> areas = {};

  static final RegExp _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  void salvar({
    required String nome,
    required String cpf,
    required String email,
    required String senha,
    required String telefone,
  }) {
    this.nome = nome.trim();
    this.cpf = cpf.replaceAll(RegExp(r'\D'), '');
    this.email = email.trim();
    this.telefone = telefone.replaceAll(RegExp(r'\D'), '');
    this.senha = senha;
  }

  void limpar() {
    nome = '';
    cpf = '';
    email = '';
    telefone = '';
    senha = '';
    cidade = '';
    formacao = '';
    experiencia = '';
    descricao = '';
    portfolio = '';
    areas = {};
  }



void salvarPerfilProfissional({
  required String cidade,
  required String formacao,
  required String experiencia,
  required String descricao,
  required String portfolio,
  required Set<String> areas,
}) {
  this.cidade = cidade.trim();
  this.formacao = formacao;
  this.experiencia = experiencia;
  this.descricao = descricao.trim();
  this.portfolio = portfolio.trim();
  this.areas = Set.of(areas);
}

void atualizarPerfil({
  required String nome,
  required String email,
  required String telefone,
  String? cidade,
  String? descricao, 
}) {
  this.nome = nome.trim();
  this.email = email.trim();
  this.telefone = telefone.replaceAll(RegExp(r'\D'), '');
  if (cidade != null) this.cidade = cidade.trim();
  if (descricao != null) this.descricao = descricao.trim();
  notifyListeners();
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



  String get cpfFormatado {
    if (cpf.length != 11) return cpf;
    return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.'
        '${cpf.substring(6, 9)}-${cpf.substring(9)}';
  }

  bool isValidEmail(String email) => _emailRegex.hasMatch(email.trim());

  bool senhasIguais(String senha, String confirmacao) => senha == confirmacao;

  bool isValidCpf(String cpf) {
    final digits = cpf.replaceAll(RegExp(r'\D'), '');

    if (digits.length != 11) return false;

    if (RegExp(r'^(\d)\1{10}$').hasMatch(digits)) return false;

    final nums = digits.split('').map(int.parse).toList();

    return _digitoVerificador(nums, 9) == nums[9] &&
        _digitoVerificador(nums, 10) == nums[10];
  }

  int _digitoVerificador(List<int> nums, int qtd) {
    int soma = 0;
    for (int i = 0; i < qtd; i++) {
      soma += nums[i] * (qtd + 1 - i);
    }
    final resto = (soma * 10) % 11;
    return resto == 10 ? 0 : resto;
  }
}