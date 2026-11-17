import 'package:flutter/material.dart';
import 'package:reparo_pro/service_locator.dart';
import 'package:reparo_pro/services/solicitacao_service.dart';

class NovaSolicitacaoView extends StatefulWidget {
  const NovaSolicitacaoView({super.key});

  @override
  State<NovaSolicitacaoView> createState() => _NovaSolicitacaoViewState();
}

class _NovaSolicitacaoViewState extends State<NovaSolicitacaoView> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _service = getIt<SolicitacaoService>();

  static const _categorias = [
    'Elétrica',
    'Hidráulica',
    'Pintura',
    'Marcenaria',
    'Ar-condicionado',
    'Eletrodomésticos',
    'Informática',
    'Celulares',
    'Reformas',
    'Chaveiro',
    'Jardinagem',
    'Limpeza',
    'Mecânica',
    'Vidraçaria',
  ];
  static const _urgencias = ['Baixa', 'Média', 'Alta'];

  String? _categoria;
  String _urgencia = 'Média';
  DateTime? _prazo;
  bool _tentouEnviar = false;
  bool _carregando = false;

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  String _formatarData(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _escolherData() async {
    final hoje = DateTime.now();
    final escolhida = await showDatePicker(
      context: context,
      initialDate: _prazo ?? hoje,
      firstDate: hoje,
      lastDate: hoje.add(const Duration(days: 365)),
    );
    if (escolhida != null) setState(() => _prazo = escolhida);
  }

  Future<void> _salvar() async {
    if (_carregando) return;
    setState(() => _tentouEnviar = true);

    if (!_formKey.currentState!.validate() || _prazo == null) return;

    setState(() => _carregando = true);

    final erro = await _service.adicionar(
      titulo: _tituloController.text,
      descricao: _descricaoController.text,
      categoria: _categoria!,
      urgencia: _urgencia,
      prazo: _prazo!,
    );

    if (!mounted) return;
    setState(() => _carregando = false);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(erro ?? 'Solicitação salva com sucesso!')),
      );

    if (erro == null) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova solicitação')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _tituloController,
                  enabled: !_carregando,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    hintText: 'Ex.: Vazamento na pia da cozinha',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Informe o título';
                    if (v.trim().length < 5) return 'Título muito curto';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  initialValue: _categoria,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(),
                  ),
                  items: _categorias
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged:
                      _carregando ? null : (v) => setState(() => _categoria = v),
                  validator: (v) => v == null ? 'Selecione a categoria' : null,
                ),
                const SizedBox(height: 20),

                const Text(
                  'Urgência',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _urgencias.map((u) {
                    final selecionada = _urgencia == u;
                    return ChoiceChip(
                      label: Text(
                        u,
                        style: TextStyle(
                          color: selecionada ? Colors.white : Colors.black87,
                        ),
                      ),
                      selected: selecionada,
                      selectedColor: Colors.black,
                      checkmarkColor: Colors.white,
                      onSelected:
                          _carregando ? null : (_) => setState(() => _urgencia = u),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                OutlinedButton.icon(
                  onPressed: _carregando ? null : _escolherData,
                  icon: const Icon(Icons.calendar_today_outlined),
                  label: Text(
                    _prazo == null
                        ? 'Prazo desejado'
                        : 'Prazo: ${_formatarData(_prazo!)}',
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                if (_tentouEnviar && _prazo == null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Selecione o prazo desejado',
                      style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _descricaoController,
                  enabled: !_carregando,
                  maxLines: 4,
                  maxLength: 300,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Descrição do problema',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().length < 10) {
                      return 'Descreva com pelo menos 10 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _carregando ? null : _salvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    disabledBackgroundColor: Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _carregando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Salvar solicitação',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}