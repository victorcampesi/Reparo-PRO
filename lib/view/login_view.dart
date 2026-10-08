import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _senhaController = TextEditingController();
  bool _ocultarSenha = true;

  @override
  void dispose() {
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.account_box, size: 60),
              SizedBox(height: 30),

              Expanded(child: Container()),

              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              TextField(
                controller: _senhaController,
                obscureText: _ocultarSenha,
                onChanged: (_) => setState(() {}), // reconstrói ao digitar
                decoration: InputDecoration(
                  labelText: 'Senha',
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

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'recuperar_senha');
                  },
                  child: Text('Esqueceu a senha?'),
                ),
              ),
              SizedBox(height: 10),

              ElevatedButton(onPressed: () {}, child: Text('entrar')),
              SizedBox(height: 40),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'saber');
                },
                child: Text('Ajuda'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}