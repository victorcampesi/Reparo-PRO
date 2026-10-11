import 'package:flutter/material.dart';

class Formacao {
  final String curso;
  final String instituicao;
  final String periodo;
  final String nivel;

  const Formacao({
    required this.curso,
    required this.instituicao,
    required this.periodo,
    required this.nivel,
  });
}

class Certificado {
  final String nome;
  final String instituicao;
  final String ano;
  final String cargaHoraria;

  const Certificado({
    required this.nome,
    required this.instituicao,
    required this.ano,
    required this.cargaHoraria,
  });
}

class PerfilPrestadorView extends StatelessWidget {
  
//Dados de exemplo...

  final String nome;
  final String email;
  final String telefone;
  final String cpf;
  final String profissao;
  final String cidade;
  final double nota;
  final int totalAvaliacoes;
  final List<Formacao> formacoes;
  final List<Certificado> certificados;

  const PerfilPrestadorView({
    super.key,
    this.nome = 'Geraldão da Manutenção',
    this.email = 'Gdm@email.com',
    this.telefone = '(11) 91234-5678',
    this.cpf = '529.982.247-25',
    this.profissao = 'Eletricista',
    this.cidade = 'São Paulo - SP',
    this.nota = 4.7,
    this.totalAvaliacoes = 38,
    this.formacoes = const [
      Formacao(
        curso: 'Técnico em Eletrotécnica',
        instituicao: 'SENAI São Paulo',
        periodo: '2015 - 2017',
        nivel: 'Ensino técnico',
      ),
      Formacao(
        curso: 'Ensino Médio Completo',
        instituicao: 'E.E. Prof. João Mendes',
        periodo: '2012 - 2014',
        nivel: 'Ensino médio',
      ),
    ],
    this.certificados = const [
      Certificado(
        nome: 'NR-10 - Segurança em Instalações Elétricas',
        instituicao: 'SENAI São Paulo',
        ano: '2022',
        cargaHoraria: '40h',
      ),
      Certificado(
        nome: 'NR-35 - Trabalho em Altura',
        instituicao: 'Centro de Treinamento SP',
        ano: '2021',
        cargaHoraria: '8h',
      ),
      Certificado(
        nome: 'Instalações Elétricas Residenciais',
        instituicao: 'Fundação Oracle',
        ano: '2019',
        cargaHoraria: '60h',
      ),
    ],
  });

  String get _iniciais {
    final partes = nome.trim().split(RegExp(r'\s+'));
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return (partes.first[0] + partes.last[0]).toUpperCase();
  }

  Widget _estrelas(double nota, {double size = 22}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final IconData icone;
        if (nota >= i + 1) {
          icone = Icons.star;
        } else if (nota >= i + 0.5) {
          icone = Icons.star_half;
        } else {
          icone = Icons.star_border;
        }
        return Icon(icone, color: Colors.amber, size: size);
      }),
    );
  }

  Widget _blocoAvaliacao() {
    return Column(
      children: [
        _estrelas(nota),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              nota.toStringAsFixed(1).replaceAll('.', ','),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '($totalAvaliacoes avaliações)',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _itemDado(IconData icone, String rotulo, String valor) {
    return ListTile(
      leading: Icon(icone),
      title: Text(
        rotulo,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        valor,
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  Widget _titulo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          texto,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _vazio(String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(texto, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _cardFormacao(Formacao f) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: const Icon(Icons.school_outlined, size: 32),
        title: Text(
          f.curso,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text('${f.instituicao}\n${f.periodo} • ${f.nivel}'),
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _cardCertificado(Certificado c) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: const Icon(Icons.workspace_premium_outlined, size: 32),
        title: Text(
          c.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text('${c.instituicao}\n${c.ano} • ${c.cargaHoraria}'),
        ),
        isThreeLine: true,
      ),
    );
  }

  // Aba 2 

  Widget _abaDados(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.black,
            child: Text(
              _iniciais,
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            nome,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(profissao, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          _blocoAvaliacao(),
          const SizedBox(height: 24),

          Card(
            child: Column(
              children: [
                _itemDado(Icons.email_outlined, 'E-mail', email),
                const Divider(height: 1),
                _itemDado(Icons.phone_outlined, 'Telefone', telefone),
                const Divider(height: 1),
                _itemDado(Icons.badge_outlined, 'CPF', cpf),
                const Divider(height: 1),
                _itemDado(Icons.location_city_outlined, 'Cidade', cidade),
              ],
            ),
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Editar perfil',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Sair'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _abaFormacao() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _titulo('Formação acadêmica'),
          if (formacoes.isEmpty)
            _vazio('Nenhuma formação cadastrada.')
          else
            ...formacoes.map(_cardFormacao),
          const SizedBox(height: 12),

          _titulo('Certificados'),
          if (certificados.isEmpty)
            _vazio('Nenhum certificado cadastrado.')
          else
            ...certificados.map(_cardCertificado),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Meu perfil'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person_outline), text: 'Dados'),
              Tab(icon: Icon(Icons.school_outlined), text: 'Formação'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              _abaDados(context),
              _abaFormacao(),
            ],
          ),
        ),
      ),
    );
  }
}