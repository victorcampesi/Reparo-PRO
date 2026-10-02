import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.login, size: 60),
              SizedBox(height: 30),

              TextField(
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
              ),

              Align(
                alignment: AlignmentGeometry.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      'recuperar_senha',
                    );
                  },
                  child: Text('Esqueceu a senha?'),
                ),
              ),
              SizedBox(height: 10),

              ElevatedButton(onPressed: () {}, child: Text('entrar')),
              SizedBox(height: 40),

              TextButton(
                onPressed: () {},
                child: Text('Ainda não tem uma conta? Cadastre-se.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
