
import 'package:flutter/material.dart';
import 'package:reparo_pro/services/auth_service.dart';
import 'package:reparo_pro/service_locator.dart';

class RecuperarSenhaController extends ChangeNotifier {
  final emailController = TextEditingController();

  bool _carregando = false;
  bool get carregando => _carregando;

  String? validarEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Informe o e-mail cadastrado';
    }

    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!regex.hasMatch(email)) {
      return 'Informe um e-mail válido';
    }

    return null;
  }

  Future<String?> recuperarSenha() async {
    if (_carregando) return null;

    _carregando = true;
    notifyListeners();

    try {
      final erro = await getIt<AuthService>()
          .recuperarSenha(emailController.text.trim());

      return erro;
    } catch (e) {
      return 'Não foi possível solicitar a recuperação da senha.';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
