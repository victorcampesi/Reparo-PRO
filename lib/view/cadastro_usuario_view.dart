import 'package:flutter/material.dart';

class CadastroUsuarioView extends StatefulWidget {
  const CadastroUsuarioView({super.key});

  @override
  State<CadastroUsuarioView> createState() => _CadastroUsuarioViewState();
}

class _CadastroUsuarioViewState extends State<CadastroUsuarioView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // seta de voltar automática
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.login, size: 60),
              SizedBox(height: 30),

              TextField(
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'CPF',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirme a senha',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 200),

              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Criar Conta',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}