
import 'package:flutter/material.dart';
import 'package:reparo_pro/controller/recuperar_senha_controller.dart';

class RecuperarSenhaView extends StatefulWidget {
  const RecuperarSenhaView({super.key});

  @override
  State<RecuperarSenhaView> createState() =>
      _RecuperarSenhaViewState();
}

class _RecuperarSenhaViewState extends State<RecuperarSenhaView> {
  final _formKey = GlobalKey<FormState>();

  late final RecuperarSenhaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RecuperarSenhaController();
    _controller.addListener(_atualizarTela);
  }

  void _atualizarTela() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_atualizarTela);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _solicitarRecuperacao() async {
    if (_controller.carregando) return;

    if (!_formKey.currentState!.validate()) return;

    final erro = await _controller.recuperarSenha();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          erro ??
              'Enviamos um link de redefinição para o seu e-mail.',
        ),
      ),
    );

    if (erro == null) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar senha'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Recuperar senha',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Informe o e-mail cadastrado para solicitar '
                  'a recuperação da sua senha.',
                ),

                const SizedBox(height: 24),

                TextFormField(
                  controller: _controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [
                    AutofillHints.email,
                  ],
                  enabled: !_controller.carregando,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: _controller.validarEmail,
                  onFieldSubmitted: (_) =>
                      _solicitarRecuperacao(),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _controller.carregando
                      ? null
                      : _solicitarRecuperacao,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    child: _controller.carregando
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Recuperar senha'),
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
