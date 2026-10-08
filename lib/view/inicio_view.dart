import 'package:flutter/material.dart';

class InicioView extends StatefulWidget {
  const InicioView({super.key});

  @override
  State<InicioView> createState() => _InicioViewState();
}

class _InicioViewState extends State<InicioView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              
              SizedBox(height: 30),

              Text('Reparo Pro', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)), // Adicionado o texto aqui
              SizedBox(height: 70),
              Icon(Icons.settings, size: 100),

              Expanded(child: Container()),

              ElevatedButton(
                onPressed: () {
                Navigator.pushNamed(context, 'tipo_usuario');
              },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, 
                  padding: EdgeInsets.symmetric(vertical: 15),
                  minimumSize: Size(double.infinity, 50), 
                ),
                child: Text(
                  'Cadastrar-se',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),

              SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'login');
              
                },
                child: Text('Já tenho uma conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
