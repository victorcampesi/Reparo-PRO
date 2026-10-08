import 'package:flutter/material.dart';

class SaberMaisView extends StatefulWidget {
  const SaberMaisView({super.key});

  @override
  State<SaberMaisView> createState() => _SaberMaisViewState();
}

class _SaberMaisViewState extends State<SaberMaisView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Icon(Icons.info_outline, size: 60)),
              SizedBox(height: 20),

              Center(
                child: Text(
                  'Conheça os tipos de conta',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),

              Center(
                child: Text(
                  'Entenda qual perfil combina mais com você.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              SizedBox(height: 30),

              _CardTipoConta(
                icone: Icons.shopping_cart_outlined,
                titulo: 'Consumidor',
                descricao:
                    'Para quem precisa de um reparo. Encontre profissionais, '
                    'solicite orçamentos e acompanhe seus serviços em um só lugar.',
              ),
              SizedBox(height: 16),

              _CardTipoConta(
                icone: Icons.person_outline,
                titulo: 'Prestador Autônomo',
                descricao:
                    'Para profissionais que trabalham por conta própria. '
                    'Divulgue seus serviços, receba pedidos e construa sua reputação.',
              ),
              SizedBox(height: 16),

              _CardTipoConta(
                icone: Icons.business_outlined,
                titulo: 'Prestador Empresa',
                descricao:
                    'Para empresas que oferecem serviços de reparo. '
                    'Cadastre sua equipe, gerencie atendimentos e amplie sua clientela.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardTipoConta extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String descricao;

  const _CardTipoConta({
    required this.icone,
    required this.titulo,
    required this.descricao,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.black,
              child: Icon(icone, color: Colors.white),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    descricao,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}