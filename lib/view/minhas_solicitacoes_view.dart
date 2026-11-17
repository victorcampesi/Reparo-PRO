import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reparo_pro/service_locator.dart';
import 'package:reparo_pro/services/solicitacao_service.dart';

class MinhasSolicitacoesView extends StatefulWidget {
  const MinhasSolicitacoesView({super.key});

  @override
  State<MinhasSolicitacoesView> createState() => _MinhasSolicitacoesViewState();
}

class _MinhasSolicitacoesViewState extends State<MinhasSolicitacoesView> {
  final _service = getIt<SolicitacaoService>();
  late Stream<QuerySnapshot<Map<String, dynamic>>> _stream;

  @override
  void initState() {
    super.initState();
    _stream = _service.listar();
  }

  void _tentarNovamente() {
    setState(() => _stream = _service.listar());
  }

  String _formatarData(Timestamp? t) {
    if (t == null) return '-';
    final d = t.toDate();
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  Color _corUrgencia(String? u) {
    switch (u) {
      case 'Alta':
        return Colors.red.shade700;
      case 'Média':
        return Colors.orange.shade800;
      default:
        return Colors.green.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas solicitações')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => Navigator.pushNamed(context, 'nova_solicitacao'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _stream,
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 56, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text(
                      'Não foi possível carregar as solicitações.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _tentarNovamente,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Você ainda não fez nenhuma solicitação.\n'
                  'Toque em + para criar a primeira.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final s = docs[i].data();
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              s['titulo'] ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            s['urgencia'] ?? '',
                            style: TextStyle(
                              color: _corUrgencia(s['urgencia']),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(s['descricao'] ?? ''),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          Chip(
                            label: Text(s['categoria'] ?? ''),
                            visualDensity: VisualDensity.compact,
                          ),
                          Chip(
                            label: Text(
                              'Prazo: ${_formatarData(s['prazo'] as Timestamp?)}',
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                          Chip(
                            label: Text('Status: ${s['status'] ?? ''}'),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}