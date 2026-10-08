import 'package:flutter/material.dart';

class TipoPrestadorView extends StatefulWidget {
  const TipoPrestadorView({super.key});

  @override
  State<TipoPrestadorView> createState() => _TipoPrestadorViewState();
}

class _TipoPrestadorViewState extends State<TipoPrestadorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.handyman_outlined, size: 60),
              SizedBox(height: 30),

              Text(
                'Como você atua?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              Text(
                'Escolha se você presta serviços por conta própria ou como empresa.',
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
                icon: Icon(Icons.person_outline, color: Colors.white),
                label: Text(
                  'Autônomo',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),

              SizedBox(height: 40),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, 'cadastro_empresa');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  minimumSize: Size(double.infinity, 50),
                ),
                icon: Icon(Icons.business_outlined, color: Colors.white),
                label: Text(
                  'Empresa',
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