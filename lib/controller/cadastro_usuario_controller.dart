class CadastroUsuarioController {
  String nome = '';
  String cpf = '';
  String email = '';
  String senha = '';

  static final RegExp _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  /// Guarda os valores 
  void salvar({
    required String nome,
    required String cpf,
    required String email,
    required String senha,
  }) {
    this.nome = nome.trim();
    this.cpf = cpf.replaceAll(RegExp(r'\D'), '');
    this.email = email.trim();
    this.senha = senha;
  }

  void limpar() {
    nome = '';
    cpf = '';
    email = '';
    senha = '';
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