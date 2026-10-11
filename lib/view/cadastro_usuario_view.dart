import 'package:flutter/material.dart';
import 'package:reparo_pro/controller/sessao_controller.dart';

class CadastroUsuarioView extends StatefulWidget {
  const CadastroUsuarioView({super.key});

  @override
  State<CadastroUsuarioView> createState() => _CadastroUsuarioViewState();
}

class _CadastroUsuarioViewState extends State<CadastroUsuarioView> {
  final _senhaController = TextEditingController();
  final _confirmacaoController = TextEditingController();
  bool _ocultarSenha = true;
  bool _ocultarConfirmacao = true;

  @override
  void dispose() {
    _senhaController.dispose();
    _confirmacaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // seta de voltar automática
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.account_box, size: 60),
              SizedBox(height: 60),

              TextField(
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Telefone',
                  prefixIcon: Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'CPF',
                  prefixIcon: Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              TextField(
                controller: _senhaController,
                obscureText: _ocultarSenha,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                  suffixIcon: _senhaController.text.isEmpty
                      ? null
                      : Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: IconButton(
                            icon: Icon(
                              _ocultarSenha
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _ocultarSenha = !_ocultarSenha;
                              });
                            },
                          ),
                        ),
                ),
              ),
              SizedBox(height: 20),

              TextField(
                controller: _confirmacaoController,
                obscureText: _ocultarConfirmacao,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: 'Confirme a senha',
                  prefixIcon: Icon(Icons.lock_reset_outlined),
                  border: OutlineInputBorder(),
                  suffixIcon: _confirmacaoController.text.isEmpty
                      ? null
                      : Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: IconButton(
                            icon: Icon(
                              _ocultarConfirmacao
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _ocultarConfirmacao = !_ocultarConfirmacao;
                              });
                            },
                          ),
                        ),
                ),
              ),

              SizedBox(height: 70),

              ElevatedButton(
                onPressed: () {
                  final tipo = SessaoController.instance.tipoConta;

                  if (tipo == TipoConta.autonomo) {
                    Navigator.pushReplacementNamed(
                      context,
                      'perguntas_prestador',
                    );
                  } else {
                    Navigator.pushReplacementNamed(context, 'preferencias');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Criar Conta',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}