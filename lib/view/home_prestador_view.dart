import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'mapa_servico_view.dart';
import 'perfil_prestador_view.dart'; 

enum StatusServico { pendente, aceito, recusado }

class Servico {
  final String titulo;
  final String cliente;
  final String endereco;
  final String data;
  final double valor;
  final double latitude;
  final double longitude;
  StatusServico status;

  Servico({
    required this.titulo,
    required this.cliente,
    required this.endereco,
    required this.data,
    required this.valor,
    required this.latitude,
    required this.longitude,
    this.status = StatusServico.pendente,
  });
}

class HomePrestadorView extends StatefulWidget {
  const HomePrestadorView({super.key});

  @override
  State<HomePrestadorView> createState() => _HomePrestadorViewState();
}

class _HomePrestadorViewState extends State<HomePrestadorView> {
  // Dados de exemplo (coordenadas fictícias de São Paulo): substitua pela sua fonte real
  final List<Servico> _servicos = [
    Servico(
      titulo: 'Instalação de chuveiro',
      cliente: 'Maria Souza',
      endereco: 'Rua das Flores, 123 - Centro',
      data: 'Hoje, 14:00',
      valor: 150.0,
      latitude: -23.5505,
      longitude: -46.6333,
    ),
    Servico(
      titulo: 'Reparo de tomadas',
      cliente: 'João Pereira',
      endereco: 'Av. Brasil, 456 - Jardim América',
      data: 'Amanhã, 09:30',
      valor: 220.0,
      latitude: -23.5614,
      longitude: -46.6559,
    ),
    Servico(
      titulo: 'Troca de fiação',
      cliente: 'Ana Lima',
      endereco: 'Rua Verde, 78 - Vila Nova',
      data: 'Sex, 16:00',
      valor: 480.0,
      latitude: -23.5329,
      longitude: -46.6395,
    ),
  ];

  String _formatarValor(double valor) =>
      'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';

  int get _qtdPendentes =>
      _servicos.where((s) => s.status == StatusServico.pendente).length;

  double get _ganhosPrevistos => _servicos
      .where((s) => s.status == StatusServico.aceito)
      .fold(0.0, (soma, s) => soma + s.valor);

  void _atualizarStatus(Servico servico, StatusServico novoStatus) {
    setState(() => servico.status = novoStatus);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            novoStatus == StatusServico.aceito
                ? 'Serviço aceito!'
                : 'Serviço recusado.',
          ),
        ),
      );
  }

  void _abrirMapa(Servico servico) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapaServicoView(
          titulo: servico.titulo,
          endereco: servico.endereco,
          destino: LatLng(servico.latitude, servico.longitude),
        ),
      ),
    );
  }

  void _abrirPerfil() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PerfilPrestadorView()),
    );
  }

  Color _corFundoStatus(StatusServico status) {
    switch (status) {
      case StatusServico.pendente:
        return Colors.orange.shade100;
      case StatusServico.aceito:
        return Colors.green.shade100;
      case StatusServico.recusado:
        return Colors.red.shade100;
    }
  }

  String _textoStatus(StatusServico status) {
    switch (status) {
      case StatusServico.pendente:
        return 'Pendente';
      case StatusServico.aceito:
        return 'Aceito';
      case StatusServico.recusado:
        return 'Recusado';
    }
  }

  Widget _cardResumo({
    required IconData icone,
    required String titulo,
    required String valor,
  }) {
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
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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

  Widget _cardServico(Servico servico) {
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
                    servico.titulo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _corFundoStatus(servico.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _textoStatus(servico.status),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _linhaInfo(Icons.person_outline, servico.cliente),
            const SizedBox(height: 6),
            _linhaInfo(Icons.location_on_outlined, servico.endereco),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => _abrirMapa(servico),
                icon: const Icon(Icons.map_outlined, size: 18),
                label: const Text('Ver no mapa'),
              ),
            ),
            _linhaInfo(Icons.schedule, servico.data),
            const SizedBox(height: 12),
            Text(
              _formatarValor(servico.valor),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (servico.status == StatusServico.pendente) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          _atualizarStatus(servico, StatusServico.recusado),
                      child: const Text('Recusar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          _atualizarStatus(servico, StatusServico.aceito),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: const Text(
                        'Aceitar',
                        style: TextStyle(color: Colors.white),
                      ),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Início'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Meu perfil',
            onPressed: _abrirPerfil,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Olá, prestador!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Veja os serviços solicitados para você.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                _cardResumo(
                  icone: Icons.attach_money,
                  titulo: 'Ganhos previstos',
                  valor: _formatarValor(_ganhosPrevistos),
                ),
                _cardResumo(
                  icone: Icons.pending_actions,
                  titulo: 'Pendentes',
                  valor: '$_qtdPendentes',
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              'Serviços solicitados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            if (_servicos.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: Text('Nenhum serviço solicitado.')),
              )
            else
              ..._servicos.map(_cardServico),
          ],
        ),
      ),
    );
  }
}