import 'package:flutter/material.dart';
import 'package:reparo_pro/controller/cadastro_usuario_controller.dart';
import 'package:reparo_pro/service_locator.dart';

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
  final double nota;
  final int totalAvaliacoes;
  final List<Formacao> formacoes;
  final List<Certificado> certificados;

  const PerfilPrestadorView({
    super.key,
    this.nota = 0,
    this.totalAvaliacoes = 0,
    this.formacoes = const [],
    this.certificados = const [],
  });

  // Dados do cadastro, lidos do controller compartilhado
  CadastroUsuarioController get _cadastro =>
      getIt<CadastroUsuarioController>();

  String get nome => _cadastro.nome.isEmpty ? 'Prestador' : _cadastro.nome;

  String get email =>
      _cadastro.email.isEmpty ? 'Não informado' : _cadastro.email;

  String get cpf =>
      _cadastro.cpf.isEmpty ? 'Não informado' : _cadastro.cpfFormatado;

  String get telefone => _cadastro.telefone.isEmpty
    ? 'Não informado'
    : _cadastro.telefoneFormatado;

  String get cidade =>
      _cadastro.cidade.isEmpty ? 'Não informado' : _cadastro.cidade;

  String get profissao => _cadastro.areas.isEmpty
      ? 'Prestador de serviços'
      : _cadastro.areas.join(', ');

  String get _iniciais {
    final partes =
        nome.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (partes.isEmpty) return '?';
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
    if (totalAvaliacoes == 0) {
      return Column(
        children: [
          _estrelas(0),
          const SizedBox(height: 6),
          const Text(
            'Ainda sem avaliações',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      );
    }

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
          Text(
            profissao,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          if (_cadastro.descricao.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(_cadastro.descricao, textAlign: TextAlign.center),
          ],
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
                Navigator.pushNamed(context, 'editar_perfil_prestador');
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
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Voltar ao início'),
            ),
          ),
        ],
      ),
    );
  }

  // Aba 2: formação e certificados
  Widget _abaFormacao() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          if (_cadastro.formacao.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: const Icon(Icons.school_outlined, size: 32),
                title: Text(
                  _cadastro.formacao,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Experiência: ${_cadastro.experiencia}'),
              ),
            ),

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
    return ListenableBuilder(
      listenable: _cadastro,
      builder: (context, _) => DefaultTabController(
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
      ),
    );
  }
}