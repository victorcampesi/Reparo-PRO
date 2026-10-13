import 'package:flutter/material.dart';
import 'package:reparo_pro/controller/cadastro_empresa_controller.dart';
import 'package:reparo_pro/service_locator.dart';
import 'package:reparo_pro/view/perfil_empresa_view.dart';

enum StatusSolicitacao { pendente, aceita, recusada }

class Solicitacao {
  final String titulo;
  final String cliente;
  final String area;
  final String tipoCliente;
  final String endereco;
  final String data;
  final double valor;
  StatusSolicitacao status;

  Solicitacao({
    required this.titulo,
    required this.cliente,
    required this.area,
    required this.tipoCliente,
    required this.endereco,
    required this.data,
    required this.valor,
    this.status = StatusSolicitacao.pendente,
  });
}

class HomeEmpresaView extends StatefulWidget {
  const HomeEmpresaView({super.key});

  @override
  State<HomeEmpresaView> createState() => _HomeEmpresaViewState();
}

class _HomeEmpresaViewState extends State<HomeEmpresaView> {
  final _empresa = getIt<CadastroEmpresaController>();

  // Dados de exemplo
  final List<Solicitacao> _solicitacoes = [
    Solicitacao(
      titulo: 'Manutenção de ar-condicionado',
      cliente: 'Condomínio Solar',
      area: 'Ar-condicionado',
      tipoCliente: 'Condomínios',
      endereco: 'Av. Paulista, 1000 - Bela Vista',
      data: 'Amanhã, 08:00',
      valor: 1800.0,
    ),
    Solicitacao(
      titulo: 'Reforma elétrica de loja',
      cliente: 'Padaria Pão Quente',
      area: 'Elétrica',
      tipoCliente: 'Comercial',
      endereco: 'Rua Augusta, 250 - Consolação',
      data: 'Sex, 10:00',
      valor: 3200.0,
    ),
    Solicitacao(
      titulo: 'Pintura de apartamento',
      cliente: 'Fernanda Alves',
      area: 'Pintura',
      tipoCliente: 'Residencial',
      endereco: 'Rua Verde, 78 - Vila Nova',
      data: 'Seg, 09:00',
      valor: 2400.0,
    ),
  ];

  String _valor(double v) {
    final partes = v.toStringAsFixed(2).split('.');
    final inteiro = partes[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[1]}.',
    );
    return 'R\$ $inteiro,${partes[1]}';
  }

  int get _pendentes =>
      _solicitacoes.where((s) => s.status == StatusSolicitacao.pendente).length;

  double get _previsto => _solicitacoes
      .where((s) => s.status == StatusSolicitacao.aceita)
      .fold(0.0, (soma, s) => soma + s.valor);

  void _atualizar(Solicitacao s, StatusSolicitacao novo) {
    setState(() => s.status = novo);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(novo == StatusSolicitacao.aceita
              ? 'Solicitação aceita!'
              : 'Solicitação recusada.'),
        ),
      );
  }

  Color _corStatus(StatusSolicitacao s) {
    switch (s) {
      case StatusSolicitacao.pendente:
        return Colors.orange.shade100;
      case StatusSolicitacao.aceita:
        return Colors.green.shade100;
      case StatusSolicitacao.recusada:
        return Colors.red.shade100;
    }
  }

  String _textoStatus(StatusSolicitacao s) {
    switch (s) {
      case StatusSolicitacao.pendente:
        return 'Pendente';
      case StatusSolicitacao.aceita:
        return 'Aceita';
      case StatusSolicitacao.recusada:
        return 'Recusada';
    }
  }

  Widget _cardResumo(IconData icone, String titulo, String valor) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icone, size: 28),
              const SizedBox(height: 12),
              Text(
                valor,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(titulo, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _linhaInfo(IconData icone, String texto) {
    return Row(
      children: [
        Icon(icone, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(child: Text(texto)),
      ],
    );
  }

  Widget _selo(String texto, IconData icone) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 14),
          const SizedBox(width: 4),
          Text(texto, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // Cartão com os dados da empresa vindos do cadastro
  Widget _cardEmpresa() {
    final e = _empresa;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.black,
                  child: Icon(Icons.storefront_outlined, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.nome.isEmpty ? 'Sua empresa' : e.nome,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (e.cnpj.isNotEmpty)
                        Text(
                          'CNPJ ${e.cnpjFormatado}',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 13),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (e.descricao.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(e.descricao),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (e.cidade.isNotEmpty)
                  _selo(e.cidade, Icons.location_city_outlined),
                if (e.funcionarios.isNotEmpty)
                  _selo('${e.funcionarios} func.', Icons.groups_outlined),
                _selo('Raio ${e.raioKm.round()} km', Icons.my_location),
                if (e.tempoResposta.isNotEmpty)
                  _selo(e.tempoResposta, Icons.timer_outlined),
                if (e.atende24h) _selo('24 horas', Icons.access_time),
                if (e.orcamentoGratis)
                  _selo('Orçamento grátis', Icons.request_quote_outlined),
              ],
            ),
            if (e.areas.isNotEmpty) ...[
              const SizedBox(height: 14),
              const Text('Áreas de atuação',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: e.areas
                    .map((a) => Chip(
                          label: Text(a,
                              style: const TextStyle(color: Colors.white)),
                          backgroundColor: Colors.black,
                          side: BorderSide.none,
                        ))
                    .toList(),
              ),
            ],
            if (e.publicos.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                'Atende: ${e.publicos.join(', ')}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _cardSolicitacao(Solicitacao s) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    s.titulo,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _corStatus(s.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(_textoStatus(s.status),
                      style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _linhaInfo(Icons.business_center_outlined,
                '${s.cliente} · ${s.tipoCliente}'),
            const SizedBox(height: 6),
            _linhaInfo(Icons.build_outlined, s.area),
            const SizedBox(height: 6),
            _linhaInfo(Icons.location_on_outlined, s.endereco),
            const SizedBox(height: 6),
            _linhaInfo(Icons.schedule, s.data),
            const SizedBox(height: 12),
            Text(
              _valor(s.valor),
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (s.status == StatusSolicitacao.pendente) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          _atualizar(s, StatusSolicitacao.recusada),
                      child: const Text('Recusar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _atualizar(s, StatusSolicitacao.aceita),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: const Text('Aceitar',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nome = _empresa.nome;

    return Scaffold(
     appBar: AppBar(
      automaticallyImplyLeading: false,
      title: const Text('Início'),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.account_circle_outlined),
          tooltip: 'Perfil da empresa',
          onPressed: () => Navigator.pushNamed(context, 'perfil_empresa')
        ),
      ],
    ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              nome.isEmpty ? 'Olá!' : 'Olá, $nome!',
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Veja as solicitações recebidas pela sua empresa.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                _cardResumo(
                    Icons.attach_money, 'Receita prevista', _valor(_previsto)),
                _cardResumo(
                    Icons.pending_actions, 'Pendentes', '$_pendentes'),
              ],
            ),
            const SizedBox(height: 16),

            _cardEmpresa(),
            const SizedBox(height: 24),

            const Text(
              'Solicitações',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            if (_solicitacoes.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: Text('Nenhuma solicitação recebida.')),
              )
            else
              ..._solicitacoes.map(_cardSolicitacao),
          ],
        ),
      ),
    );
  }
}