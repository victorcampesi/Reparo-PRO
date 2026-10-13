import 'dart:async';
import 'package:flutter/material.dart';

enum _Etapa { formulario, buscando, encontrado, confirmado }

class _Profissional {
  final String nome;
  final String area;
  final double nota;
  final double distanciaKm;
  final int etaMin;
  final double preco;
  final bool empresa;

  const _Profissional({
    required this.nome,
    required this.area,
    required this.nota,
    required this.distanciaKm,
    required this.etaMin,
    required this.preco,
    this.empresa = false,
  });
}

class BuscarServicoView extends StatefulWidget {
  const BuscarServicoView({super.key});

  @override
  State<BuscarServicoView> createState() => _BuscarServicoViewState();
}

class _BuscarServicoViewState extends State<BuscarServicoView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _enderecoController = TextEditingController();

  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  Timer? _timer;
  _Etapa _etapa = _Etapa.formulario;
  String? _area;
  bool _urgente = false;
  bool _tentouEnviar = false;

  List<_Profissional> _candidatos = [];
  int _indice = 0;

  static const List<String> _areas = [
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

  static const Map<String, String> _nomes = {
    'Elétrica': 'Carlos Eletricista',
    'Hidráulica': 'HidroFix Desentupidora',
    'Pintura': 'Marina Pinturas',
    'Marcenaria': 'Madeira & Arte',
    'Ar-condicionado': 'Climatiza Express',
    'Eletrodomésticos': 'Jorge Reparos',
    'Informática': 'TechSolve Informática',
    'Celulares': 'Rafa Celulares',
    'Reformas': 'Construtora Alicerce',
    'Chaveiro': 'Chaveiro 24h do Zé',
    'Jardinagem': 'Verde Vida Jardins',
    'Limpeza': 'Dona Lúcia Limpezas',
    'Mecânica': 'Auto Center Silva',
    'Vidraçaria': 'Vidros Transparência',
  };

  @override
  void dispose() {
    _timer?.cancel();
    _anim.dispose();
    _descricaoController.dispose();
    _enderecoController.dispose();
    super.dispose();
  }

  // Dados de exemplo: troque por uma busca real
  List<_Profissional> _gerarCandidatos(String area) {
    return [
      _Profissional(
        nome: _nomes[area] ?? 'Profissional',
        area: area,
        nota: 4.9,
        distanciaKm: 1.2,
        etaMin: 8,
        preco: 120,
      ),
      _Profissional(
        nome: '$area Express',
        area: area,
        nota: 4.7,
        distanciaKm: 2.5,
        etaMin: 15,
        preco: 95,
        empresa: true,
      ),
      _Profissional(
        nome: 'Serviços de $area Já',
        area: area,
        nota: 4.5,
        distanciaKm: 4.1,
        etaMin: 22,
        preco: 80,
      ),
    ];
  }

  String _preco(double v) => 'R\$ ${v.toStringAsFixed(2).replaceAll('.', ',')}';

  void _iniciarBusca() {
    setState(() => _tentouEnviar = true);
    final ok = _formKey.currentState!.validate();
    if (!ok || _area == null) return;

    FocusScope.of(context).unfocus();
    _candidatos = _gerarCandidatos(_area!);
    _indice = 0;
    _buscar();
  }

  void _buscar() {
    setState(() => _etapa = _Etapa.buscando);
    _timer?.cancel();
    _timer = Timer(Duration(seconds: _urgente ? 3 : 5), () {
      if (!mounted || _etapa != _Etapa.buscando) return;
      setState(() => _etapa = _Etapa.encontrado);
    });
  }

  void _buscarOutro() {
    if (_indice + 1 >= _candidatos.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não há mais profissionais disponíveis.')),
      );
      _cancelarBusca();
      return;
    }
    _indice++;
    _buscar();
  }

  void _cancelarBusca() {
    _timer?.cancel();
    setState(() => _etapa = _Etapa.formulario);
  }

  void _confirmar() {
    setState(() => _etapa = _Etapa.confirmado);
  }

  // ---------- Widgets ----------

  Widget _titulo(String texto) => Text(
        texto,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      );

  Widget _estrelas(double nota) {
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
        return Icon(icone, color: Colors.amber, size: 18);
      }),
    );
  }

  Widget _formulario() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Icon(Icons.travel_explore, size: 60)),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Do que você precisa?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Vamos procurar o profissional mais próximo de você.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 28),

            _titulo('Tipo de serviço'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _areas.map((area) {
                final selecionada = _area == area;
                return ChoiceChip(
                  label: Text(
                    area,
                    style: TextStyle(
                      color: selecionada ? Colors.white : Colors.black87,
                    ),
                  ),
                  selected: selecionada,
                  selectedColor: Colors.black,
                  checkmarkColor: Colors.white,
                  onSelected: (_) => setState(() => _area = area),
                );
              }).toList(),
            ),
            if (_tentouEnviar && _area == null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Selecione o tipo de serviço',
                  style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                ),
              ),
            const SizedBox(height: 24),

            TextFormField(
              controller: _enderecoController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Endereço do serviço',
                prefixIcon: Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Informe o endereço'
                  : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _descricaoController,
              maxLines: 3,
              maxLength: 200,
              decoration: const InputDecoration(
                labelText: 'Descreva o problema',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().length < 10)
                  ? 'Escreva pelo menos 10 caracteres'
                  : null,
            ),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('É urgente'),
              subtitle: const Text('Prioriza quem pode chegar mais rápido'),
              value: _urgente,
              activeThumbColor: Colors.black,
              onChanged: (v) => setState(() => _urgente = v),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _iniciarBusca,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Buscar profissional',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _onda(double t) {
    final tamanho = 64 + 156 * t;
    return Opacity(
      opacity: (1 - t).clamp(0.0, 1.0),
      child: Container(
        width: tamanho,
        height: tamanho,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 2),
        ),
      ),
    );
  }

  Widget _buscando() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            width: 220,
            height: 220,
            child: AnimatedBuilder(
              animation: _anim,
              builder: (context, _) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    for (final atraso in const [0.0, 0.33, 0.66])
                      _onda((_anim.value + atraso) % 1.0),
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.black,
                      child:
                          Icon(Icons.search, color: Colors.white, size: 30),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Procurando profissionais de $_area...',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Isso leva só alguns segundos.',
            style: TextStyle(color: Colors.grey),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _cancelarBusca,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Cancelar busca'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _info(IconData icone, String texto) {
    return Row(
      children: [
        Icon(icone, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(child: Text(texto)),
      ],
    );
  }

  Widget _cardProfissional(_Profissional p, {required bool aCaminho}) {
    final partes = p.nome.split(' ').where((s) => s.isNotEmpty);
    final iniciais = partes.take(2).map((s) => s[0]).join().toUpperCase();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.black,
                  child: Text(
                    iniciais,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              p.nome,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (p.empresa) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.verified,
                                size: 16, color: Colors.blueGrey),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _estrelas(p.nota),
                          const SizedBox(width: 6),
                          Text(p.nota.toStringAsFixed(1).replaceAll('.', ',')),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _info(Icons.build_outlined,
                '${p.area} · ${p.empresa ? 'Empresa' : 'Autônomo'}'),
            const SizedBox(height: 6),
            _info(
              Icons.near_me_outlined,
              '${p.distanciaKm.toStringAsFixed(1).replaceAll('.', ',')} km de você',
            ),
            const SizedBox(height: 6),
            _info(
              Icons.schedule,
              aCaminho
                  ? 'Chega em aproximadamente ${p.etaMin} min'
                  : 'Pode chegar em ${p.etaMin} min',
            ),
            const SizedBox(height: 12),
            Text(
              'A partir de ${_preco(p.preco)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _encontrado() {
    final p = _candidatos[_indice];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Encontramos um profissional!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Confirme para ele ir até você.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          _cardProfissional(p, aCaminho: false),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _confirmar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Confirmar profissional',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _buscarOutro,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Buscar outro'),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: _cancelarBusca,
              child: const Text('Cancelar'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _confirmado() {
    final p = _candidatos[_indice];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Icon(Icons.check_circle_outline,
                size: 72, color: Colors.green),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Profissional a caminho!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          _cardProfissional(p, aCaminho: true),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titulo('Seu pedido'),
                  const SizedBox(height: 8),
                  _info(Icons.location_on_outlined, _enderecoController.text),
                  const SizedBox(height: 6),
                  _info(Icons.description_outlined, _descricaoController.text),
                  if (_urgente) ...[
                    const SizedBox(height: 6),
                    _info(Icons.bolt, 'Atendimento urgente'),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Voltar ao início',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget corpo;
    switch (_etapa) {
      case _Etapa.formulario:
        corpo = _formulario();
      case _Etapa.buscando:
        corpo = _buscando();
      case _Etapa.encontrado:
        corpo = _encontrado();
      case _Etapa.confirmado:
        corpo = _confirmado();
    }

    return PopScope(
      canPop: _etapa == _Etapa.formulario || _etapa == _Etapa.confirmado,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _cancelarBusca();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Buscar serviço')),
        body: SafeArea(child: corpo),
      ),
    );
  }
}