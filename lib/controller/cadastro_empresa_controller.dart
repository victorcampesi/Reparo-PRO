class CadastroEmpresaController {
  static final RegExp _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  static const List<int> _pesos1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
  static const List<int> _pesos2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

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