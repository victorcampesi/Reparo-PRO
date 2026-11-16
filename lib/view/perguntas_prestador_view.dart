import 'package:flutter/material.dart';
import 'package:reparo_pro/controller/cadastro_usuario_controller.dart';
import 'package:reparo_pro/controller/sessao_controller.dart';
import 'package:reparo_pro/service_locator.dart';

class PerguntasPrestadorView extends StatefulWidget {
  const PerguntasPrestadorView({super.key});

  @override
  State<PerguntasPrestadorView> createState() => _PerguntasPrestadorViewState();
}

class _PerguntasPrestadorViewState extends State<PerguntasPrestadorView> {
  final _formKey = GlobalKey<FormState>();

  final _cidadeController = TextEditingController();
  final _portfolioController = TextEditingController();
  final _descricaoController = TextEditingController();

  final List<String> _faixasExperiencia = const [
    'Menos de 1 ano',
    '1 a 3 anos',
    '4 a 10 anos',
    'Mais de 10 anos',
  ];
  String? _experienciaSelecionada;

  final List<String> _formacoes = const [
    'Autodidata / experiência prática',
    'Curso profissionalizante',
    'Curso técnico',
    'Ensino superior',
    'Outra',
  ];
  String? _formacao;

  final List<String> _areas = const [
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
  final Set<String> _areasSelecionadas = {};

  final List<String> _dias = const [
    'Seg',
    'Ter',
    'Qua',
    'Qui',
    'Sex',
    'Sáb',
    'Dom',
  ];
  final Set<String> _diasSelecionados = {};

  final List<String> _temposResposta = const [
    'Imediato (até 1 hora)',
    'No mesmo dia',
    'Até 24 horas',
    'Até 3 dias',
  ];
  String? _tempoResposta;

  final List<String> _garantias = const [
    'Sem garantia',
    '30 dias',
    '90 dias',
    '6 meses',
    '1 ano ou mais',
  ];
  String? _garantia;

  double _raioKm = 15;
  bool _ferramentasProprias = true;
  bool _atendeEmergencia = false;
  bool _orcamentoGratis = true;
  bool _tentouEnviar = false;
  bool _carregando = false; // NOVO

  @override
  void dispose() {
    _cidadeController.dispose();
    _portfolioController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _alternar(Set<String> conjunto, String valor) {
    setState(() {
      if (conjunto.contains(valor)) {
        conjunto.remove(valor);
      } else {
        conjunto.add(valor);
      }
    });
  }

  // ALTERADO: agora cria a conta no Firebase
  Future<void> _finalizar() async {
    if (_carregando) return;
    setState(() => _tentouEnviar = true);

    final camposValidos = _formKey.currentState!.validate();
    final selecoesValidas = _experienciaSelecionada != null &&
        _areasSelecionadas.isNotEmpty &&
        _diasSelecionados.isNotEmpty;

    if (!camposValidos || !selecoesValidas) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios.')),
      );
      return;
    }

    final controller = getIt<CadastroUsuarioController>();
    controller.salvarPerfilProfissional(
      cidade: _cidadeController.text,
      formacao: _formacao ?? '',
      experiencia: _experienciaSelecionada ?? '',
      descricao: _descricaoController.text,
      portfolio: _portfolioController.text,
      areas: _areasSelecionadas,
    );

    setState(() => _carregando = true);

    final erro = await controller.criarConta(
      tipo: TipoConta.autonomo,
      extras: {
        'diasAtendimento': _diasSelecionados.toList(),
        'raioKm': _raioKm.round(),
        'tempoResposta': _tempoResposta ?? '',
        'garantia': _garantia ?? '',
        'ferramentasProprias': _ferramentasProprias,
        'atendeEmergencia': _atendeEmergencia,
        'orcamentoGratis': _orcamentoGratis,
      },
    );

    if (!mounted) return;
    setState(() => _carregando = false);

    if (erro != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(erro)));
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Conta criada com sucesso!')),
      );
    Navigator.pushNamedAndRemoveUntil(context, 'home_prestador', (_) => false);
  }

  Widget _erro(String mensagem) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        mensagem,
        style: TextStyle(color: Colors.red.shade700, fontSize: 12),
      ),
    );
  }

  Widget _titulo(String texto) {
    return Text(
      texto,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: Icon(Icons.engineering_outlined, size: 60)),
                const SizedBox(height: 20),

                const Center(
                  child: Text(
                    'Conte-nos sobre você',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),

                const Center(
                  child: Text(
                    'Essas informações ajudam os clientes a conhecer seu trabalho.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 30),

                TextFormField(
                  controller: _cidadeController,
                  enabled: !_carregando,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Cidade-base',
                    prefixIcon: Icon(Icons.location_city_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe a cidade onde você atua';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                _titulo('Há quanto tempo você trabalha na área?'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _faixasExperiencia.map((faixa) {
                    final selecionada = _experienciaSelecionada == faixa;
                    return ChoiceChip(
                      label: Text(
                        faixa,
                        style: TextStyle(
                          color: selecionada ? Colors.white : Colors.black87,
                        ),
                      ),
                      selected: selecionada,
                      selectedColor: Colors.black,
                      checkmarkColor: Colors.white,
                      onSelected: (_) {
                        setState(() => _experienciaSelecionada = faixa);
                      },
                    );
                  }).toList(),
                ),
                if (_tentouEnviar && _experienciaSelecionada == null)
                  _erro('Selecione seu tempo de experiência'),
                const SizedBox(height: 28),

                DropdownButtonFormField<String>(
                  initialValue: _formacao,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Formação',
                    prefixIcon: Icon(Icons.school_outlined),
                    border: OutlineInputBorder(),
                  ),
                  items: _formacoes
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                  onChanged: (valor) => setState(() => _formacao = valor),
                  validator: (valor) =>
                      valor == null ? 'Selecione sua formação' : null,
                ),
                const SizedBox(height: 28),


                _titulo('Em quais áreas você atua?'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _areas.map((area) {
                    final selecionada = _areasSelecionadas.contains(area);
                    return FilterChip(
                      label: Text(
                        area,
                        style: TextStyle(
                          color: selecionada ? Colors.white : Colors.black87,
                        ),
                      ),
                      selected: selecionada,
                      selectedColor: Colors.black,
                      checkmarkColor: Colors.white,
                      onSelected: (_) => _alternar(_areasSelecionadas, area),
                    );
                  }).toList(),
                ),
                if (_tentouEnviar && _areasSelecionadas.isEmpty)
                  _erro('Selecione pelo menos uma área'),
                const SizedBox(height: 28),

                _titulo('Em quais dias você atende?'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _dias.map((dia) {
                    final selecionado = _diasSelecionados.contains(dia);
                    return FilterChip(
                      label: Text(
                        dia,
                        style: TextStyle(
                          color: selecionado ? Colors.white : Colors.black87,
                        ),
                      ),
                      selected: selecionado,
                      selectedColor: Colors.black,
                      checkmarkColor: Colors.white,
                      onSelected: (_) => _alternar(_diasSelecionados, dia),
                    );
                  }).toList(),
                ),
                if (_tentouEnviar && _diasSelecionados.isEmpty)
                  _erro('Selecione pelo menos um dia'),
                const SizedBox(height: 28),

                // --- Raio de atendimento ---
                _titulo('Raio de atendimento: ${_raioKm.round()} km'),
                Slider(
                  value: _raioKm,
                  min: 5,
                  max: 100,
                  divisions: 19,
                  activeColor: Colors.black,
                  label: '${_raioKm.round()} km',
                  onChanged: (valor) => setState(() => _raioKm = valor),
                ),
                const SizedBox(height: 12),

                // --- Tempo de resposta ---
                DropdownButtonFormField<String>(
                  initialValue: _tempoResposta,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Tempo médio de resposta',
                    prefixIcon: Icon(Icons.timer_outlined),
                    border: OutlineInputBorder(),
                  ),
                  items: _temposResposta
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (valor) => setState(() => _tempoResposta = valor),
                  validator: (valor) =>
                      valor == null ? 'Selecione o tempo de resposta' : null,
                ),
                const SizedBox(height: 16),

                // --- Garantia ---
                DropdownButtonFormField<String>(
                  initialValue: _garantia,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Garantia oferecida nos serviços',
                    prefixIcon: Icon(Icons.verified_user_outlined),
                    border: OutlineInputBorder(),
                  ),
                  items: _garantias
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (valor) => setState(() => _garantia = valor),
                  validator: (valor) =>
                      valor == null ? 'Selecione a garantia oferecida' : null,
                ),
                const SizedBox(height: 12),

                // --- Switches ---
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Possuo ferramentas próprias'),
                  subtitle:
                      const Text('Levo o que preciso para executar o serviço'),
                  value: _ferramentasProprias,
                  activeThumbColor: Colors.black,
                  onChanged: (valor) =>
                      setState(() => _ferramentasProprias = valor),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Atendo emergências'),
                  subtitle: const Text('Noites, fins de semana e feriados'),
                  value: _atendeEmergencia,
                  activeThumbColor: Colors.black,
                  onChanged: (valor) =>
                      setState(() => _atendeEmergencia = valor),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Orçamento gratuito'),
                  subtitle: const Text(
                      'Não cobro pela visita ou avaliação inicial'),
                  value: _orcamentoGratis,
                  activeThumbColor: Colors.black,
                  onChanged: (valor) =>
                      setState(() => _orcamentoGratis = valor),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _portfolioController,
                  enabled: !_carregando,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'Portfólio ou Instagram (opcional)',
                    prefixIcon: Icon(Icons.link),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _descricaoController,
                  enabled: !_carregando,
                  maxLines: 4,
                  maxLength: 200,
                  decoration: const InputDecoration(
                    labelText: 'Apresente-se em poucas palavras',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.trim().length < 20) {
                      return 'Escreva pelo menos 20 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _carregando ? null : _finalizar,
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
                          'Concluir cadastro',
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