import 'package:flutter/material.dart';
import 'package:reparo_pro/controller/cadastro_empresa_controller.dart';
import 'package:reparo_pro/service_locator.dart';

class PerguntasEmpresaView extends StatefulWidget {
  const PerguntasEmpresaView({super.key});

  @override
  State<PerguntasEmpresaView> createState() => _PerguntasEmpresaViewState();
}

class _PerguntasEmpresaViewState extends State<PerguntasEmpresaView> {
  final _formKey = GlobalKey<FormState>();

  final _cidadeController = TextEditingController();
  final _linkController = TextEditingController();
  final _descricaoController = TextEditingController();

  final List<String> _faixasFuncionarios = const [
    'Somente eu',
    '2 a 5',
    '6 a 20',
    '21 a 50',
    'Mais de 50',
  ];
  String? _faixaSelecionada;

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

  final List<String> _publicos = const [
    'Residencial',
    'Comercial',
    'Industrial',
    'Condomínios',
  ];
  final Set<String> _publicosSelecionados = {};

  final List<String> _temposResposta = const [
    'Imediato (até 1 hora)',
    'No mesmo dia',
    'Até 24 horas',
    'Até 3 dias',
  ];
  String? _tempoResposta;

  double _raioKm = 20;
  bool _atende24h = false;
  bool _orcamentoGratis = true;

  // Só mostra os erros das seleções depois da primeira tentativa de envio
  bool _tentouEnviar = false;

  @override
  void dispose() {
    _cidadeController.dispose();
    _linkController.dispose();
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

  void _finalizar() {
    setState(() => _tentouEnviar = true);

    final camposValidos = _formKey.currentState!.validate();
    final selecoesValidas = _faixaSelecionada != null &&
        _areasSelecionadas.isNotEmpty &&
        _publicosSelecionados.isNotEmpty;

    if (!camposValidos || !selecoesValidas) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos obrigatórios.')),
      );
      return;
    }

    // Guarda o perfil da empresa no controller compartilhado
    getIt<CadastroEmpresaController>().salvarPerfil(
      cidade: _cidadeController.text,
      funcionarios: _faixaSelecionada ?? '',
      tempoResposta: _tempoResposta ?? '',
      link: _linkController.text,
      descricao: _descricaoController.text,
      raioKm: _raioKm,
      atende24h: _atende24h,
      orcamentoGratis: _orcamentoGratis,
      areas: _areasSelecionadas,
      publicos: _publicosSelecionados,
    );

    Navigator.pushReplacementNamed(context, 'home_empresa');
  }

  Widget _erro(String mensagem) {
    return Padding(
      padding: EdgeInsets.only(top: 6),
      child: Text(
        mensagem,
        style: TextStyle(color: Colors.red.shade700, fontSize: 12),
      ),
    );
  }

  Widget _titulo(String texto) {
    return Text(
      texto,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Icon(Icons.storefront_outlined, size: 60)),
                SizedBox(height: 20),

                Center(
                  child: Text(
                    'Conte-nos sobre sua empresa',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),

                Center(
                  child: Text(
                    'Essas informações ajudam os clientes a encontrar você.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 30),

                // --- Cidade-base ---
                TextFormField(
                  controller: _cidadeController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Cidade-base',
                    prefixIcon: Icon(Icons.location_city_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe a cidade onde a empresa atua';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 28),

                // --- Quantidade de funcionários ---
                _titulo('Quantos funcionários a empresa possui?'),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _faixasFuncionarios.map((faixa) {
                    final selecionada = _faixaSelecionada == faixa;
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
                        setState(() => _faixaSelecionada = faixa);
                      },
                    );
                  }).toList(),
                ),
                if (_tentouEnviar && _faixaSelecionada == null)
                  _erro('Selecione uma faixa de funcionários'),
                SizedBox(height: 28),

                // --- Áreas de atuação ---
                _titulo('Em quais áreas a empresa atua?'),
                SizedBox(height: 10),
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
                SizedBox(height: 28),

                // --- Público atendido ---
                _titulo('Que tipo de cliente vocês atendem?'),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _publicos.map((publico) {
                    final selecionado = _publicosSelecionados.contains(publico);
                    return FilterChip(
                      label: Text(
                        publico,
                        style: TextStyle(
                          color: selecionado ? Colors.white : Colors.black87,
                        ),
                      ),
                      selected: selecionado,
                      selectedColor: Colors.black,
                      checkmarkColor: Colors.white,
                      onSelected: (_) =>
                          _alternar(_publicosSelecionados, publico),
                    );
                  }).toList(),
                ),
                if (_tentouEnviar && _publicosSelecionados.isEmpty)
                  _erro('Selecione pelo menos um tipo de cliente'),
                SizedBox(height: 28),

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
                SizedBox(height: 12),

                // --- Tempo de resposta ---
                DropdownButtonFormField<String>(
                  initialValue: _tempoResposta,
                  decoration: InputDecoration(
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
                SizedBox(height: 12),

                // --- Switches ---
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Atendimento 24 horas'),
                  subtitle: Text('Inclui emergências, noites e fins de semana'),
                  value: _atende24h,
                  activeThumbColor: Colors.black,
                  onChanged: (valor) => setState(() => _atende24h = valor),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Orçamento gratuito'),
                  subtitle: Text('Não cobra pela visita ou avaliação inicial'),
                  value: _orcamentoGratis,
                  activeThumbColor: Colors.black,
                  onChanged: (valor) => setState(() => _orcamentoGratis = valor),
                ),
                SizedBox(height: 16),

                TextFormField(
                  controller: _linkController,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    labelText: 'Site ou Instagram (opcional)',
                    prefixIcon: Icon(Icons.link),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),

                TextFormField(
                  controller: _descricaoController,
                  maxLines: 4,
                  maxLength: 200,
                  decoration: InputDecoration(
                    labelText: 'Descreva sua empresa em poucas palavras',
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
                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _finalizar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
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