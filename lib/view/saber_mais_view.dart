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
                  'Sobre o Reparo PRO',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),

              Center(
                child: Text(
                  'Conheça o projeto e a equipe por trás dele.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              SizedBox(height: 30),

              // --- Informações obrigatórias (RF004) ---
              _CardInfo(
                icone: Icons.flag_outlined,
                titulo: 'Objetivo',
                descricao:
                    'Facilitar a comunicação e a interação entre clientes e '
                    'prestadores de serviços de reparo, sejam eles autônomos '
                    'ou empresas, reunindo busca, orçamentos e acompanhamento '
                    'dos serviços em um só lugar.',
              ),
              SizedBox(height: 16),

              _CardInfo(
                icone: Icons.groups_outlined,
                titulo: 'Equipe de desenvolvimento',
                descricao: 'Victor Gabriel Souza Campesi\nLucas Cunha Barbosa',
                // Se for em dupla: 'Victor [SOBRENOME]\nNome do colega'
              ),
              SizedBox(height: 16),

              // --- Informações opcionais ---
              _CardInfo(
                icone: Icons.school_outlined,
                titulo: 'Disciplina',
                descricao: 'Programação para Dispositivos Móveis',
              ),
              SizedBox(height: 16),

              _CardInfo(
                icone: Icons.account_balance_outlined,
                titulo: 'Instituição',
                descricao: 'FATEC Ribeirão Preto',
              ),
              SizedBox(height: 16),

              _CardInfo(
                icone: Icons.person_outline,
                titulo: 'Professor',
                descricao: 'Rodrigo de Oliveira Plotze',
              ),
              SizedBox(height: 16),

              _CardInfo(
                icone: Icons.tag,
                titulo: 'Versão',
                descricao: '1.0.0',
              ),

              // --- Seção extra: tipos de conta ---
              SizedBox(height: 32),
              Text(
                'Tipos de conta',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              _CardInfo(
                icone: Icons.shopping_cart_outlined,
                titulo: 'Consumidor',
                descricao:
                    'Para quem precisa de um reparo. Encontre profissionais, '
                    'solicite orçamentos e acompanhe seus serviços em um só lugar.',
              ),
              SizedBox(height: 16),

              _CardInfo(
                icone: Icons.person_outline,
                titulo: 'Prestador Autônomo',
                descricao:
                    'Para profissionais que trabalham por conta própria. '
                    'Divulgue seus serviços, receba pedidos e construa sua reputação.',
              ),
              SizedBox(height: 16),

              _CardInfo(
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

class _CardInfo extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String descricao;

  const _CardInfo({
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