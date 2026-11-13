import 'package:flutter/material.dart';
import 'package:reparo_pro/service_locator.dart';
import 'package:reparo_pro/services/auth_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _auth = getIt<AuthService>();

  bool _ocultarSenha = true;
  bool _carregando = false;
  String? _erro;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _carregando = true;
      _erro = null;
    });

    final erro = await _auth.login(
      _emailController.text,
      _senhaController.text,
    );

    if (!mounted) return;
    setState(() => _carregando = false);

    if (erro != null) {
      setState(() => _erro = erro);
      return;
    }

    Navigator.pushNamedAndRemoveUntil(context, 'home_usuario', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(Icons.account_box, size: 60),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  enabled: !_carregando,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Informe o e-mail';
                    if (!v.contains('@')) return 'E-mail inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _senhaController,
                  enabled: !_carregando,
                  obscureText: _ocultarSenha,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _entrar(),
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _ocultarSenha ? Icons.visibility : Icons.visibility_off,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _ocultarSenha = !_ocultarSenha),
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Informe a senha' : null,
                ),
                if (_erro != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _erro!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _carregando
                        ? null
                        : () => Navigator.pushNamed(context, 'recuperar_senha'),
                    child: const Text('Esqueceu a senha?'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _carregando ? null : _entrar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _carregando
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Entrar',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}