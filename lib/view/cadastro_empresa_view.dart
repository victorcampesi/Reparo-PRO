import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reparo_pro/controller/cadastro_empresa_controller.dart';
import 'package:reparo_pro/service_locator.dart';

class CadastroEmpresaView extends StatefulWidget {
  const CadastroEmpresaView({super.key});

  @override
  State<CadastroEmpresaView> createState() => _CadastroEmpresaViewState();
}

class _CadastroEmpresaViewState extends State<CadastroEmpresaView> {
  final _formKey = GlobalKey<FormState>();

  // Mesma instância que a home e o perfil leem
  final _controller = getIt<CadastroEmpresaController>();

  final _nomeController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmacaoController = TextEditingController();
  final _telefoneController = TextEditingController();
  bool _ocultarSenha = true;
  bool _ocultarConfirmacao = true;

  @override
  void dispose() {
    _nomeController.dispose();
    _cnpjController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmacaoController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  void _criarConta() {
    if (!_formKey.currentState!.validate()) return;

    _controller.salvar(
      nome: _nomeController.text,
      cnpj: _cnpjController.text,
      email: _emailController.text,
      senha: _senhaController.text,
      telefone: _telefoneController.text,
    );

    Navigator.pushNamed(context, 'perguntas_empresa');
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
                const Icon(Icons.business_outlined, size: 60),
                const SizedBox(height: 60),

                TextFormField(
                  controller: _nomeController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Nome da Empresa',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _cnpjController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(14),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'CNPJ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o CNPJ';
                    }
                    if (!_controller.isValidCnpj(value)) {
                      return 'CNPJ inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'E-mail Corporativo',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o e-mail';
                    }
                    if (!_controller.isValidEmail(value)) {
                      return 'E-mail inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _telefoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Telefone (com DDD)',
                    hintText: '11912345678',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o telefone';
                    }
                    if (!_controller.isValidTelefone(value)) {
                      return 'Telefone inválido';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _senhaController,
                  obscureText: _ocultarSenha,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: const OutlineInputBorder(),
                    suffixIcon: _senhaController.text.isEmpty
                        ? null
                        : Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: IconButton(
                              icon: Icon(
                                _ocultarSenha
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 20,
                              ),
                              onPressed: () => setState(
                                () => _ocultarSenha = !_ocultarSenha,
                              ),
                            ),
                          ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a senha';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _confirmacaoController,
                  obscureText: _ocultarConfirmacao,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => setState(() {}),
                  onFieldSubmitted: (_) => _criarConta(),
                  decoration: InputDecoration(
                    labelText: 'Confirme a senha',
                    border: const OutlineInputBorder(),
                    suffixIcon: _confirmacaoController.text.isEmpty
                        ? null
                        : Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: IconButton(
                              icon: Icon(
                                _ocultarConfirmacao
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 20,
                              ),
                              onPressed: () => setState(
                                () => _ocultarConfirmacao = !_ocultarConfirmacao,
                              ),
                            ),
                          ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirme a senha';
                    }
                    if (!_controller.senhasIguais(_senhaController.text, value)) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 70),

                ElevatedButton(
                  onPressed: _criarConta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Criar Conta',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}