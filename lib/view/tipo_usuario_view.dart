import 'package:flutter/material.dart';

class TipoUsuarioView extends StatefulWidget {
  const TipoUsuarioView({super.key});

  @override
  State<TipoUsuarioView> createState() => _TipoUsuarioViewState();
}

class _TipoUsuarioViewState extends State<TipoUsuarioView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.merge_type_outlined, size: 60),
              SizedBox(height: 30),

              Text(
                'Escolha o tipo de conta',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              Text(
                'Selecione como você deseja usar o aplicativo.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              SizedBox(height: 120),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, 'cadastro_usuario');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  minimumSize: Size(double.infinity, 50),
                ),
                icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
                label: Text(
                  'Consumidor',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),

              SizedBox(height: 40),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, 'tipo_prestador');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  minimumSize: Size(double.infinity, 50),
                ),
                icon: Icon(Icons.build_outlined, color: Colors.white),
                label: Text(
                  'Prestador de Serviço',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}