import 'package:flutter/material.dart';
import 'package:reparo_pro/controller/preferencias_controller.dart';
import 'package:reparo_pro/controller/cadastro_usuario_controller.dart';
import 'package:reparo_pro/service_locator.dart';
import 'package:reparo_pro/services/auth_service.dart';

class AreaServico {
  final String nome;
  final IconData icone;

  const AreaServico(this.nome, this.icone);
}

class PreferenciasView extends StatefulWidget {
  const PreferenciasView({super.key});

  @override
  State<PreferenciasView> createState() => _PreferenciasViewState();
}

class _PreferenciasViewState extends State<PreferenciasView> {
  static const int _minimoSelecionado = 1;

  final List<AreaServico> _areas = const [
    AreaServico('Elétrica', Icons.electrical_services_outlined),
    AreaServico('Hidráulica', Icons.plumbing_outlined),
    AreaServico('Pintura', Icons.format_paint_outlined),
    AreaServico('Marcenaria', Icons.carpenter_outlined),
    AreaServico('Ar-condicionado', Icons.ac_unit_outlined),
    AreaServico('Eletrodomésticos', Icons.kitchen_outlined),
    AreaServico('Informática', Icons.computer_outlined),
    AreaServico('Celulares', Icons.smartphone_outlined),
    AreaServico('Reformas', Icons.construction_outlined),
    AreaServico('Chaveiro', Icons.key_outlined),
    AreaServico('Jardinagem', Icons.yard_outlined),
    AreaServico('Limpeza', Icons.cleaning_services_outlined),
    AreaServico('Mecânica', Icons.car_repair_outlined),
    AreaServico('Vidraçaria', Icons.window_outlined),
  ];

  final Set<String> _selecionadas = {};
  final _cadastro = getIt<CadastroUsuarioController>();
  final _auth = getIt<AuthService>();
  bool _carregando = false;

  // true = já existe conta logada (edição); false = fluxo de cadastro
  bool get _jaLogado => _auth.usuarioAtual != null;

  void _alternar(String nome) {
    setState(() {
      if (_selecionadas.contains(nome)) {
        _selecionadas.remove(nome);
      } else {
        _selecionadas.add(nome);
      }
    });
  }

  Future<void> _finalizar({required bool comPreferencias}) async {
    if (_carregando) return;
    setState(() => _carregando = true);

    final jaLogado = _jaLogado;
    final prefs = comPreferencias ? Set<String>.of(_selecionadas) : <String>{};

    final erro = jaLogado
        ? await _auth.salvarPreferencias(prefs)
        : await _cadastro.criarConta(preferencias: prefs);

    if (!mounted) return;
    setState(() => _carregando = false);

    if (erro != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(erro)));
      return;
    }

    if (comPreferencias) {
      PreferenciasController.instance.definir(prefs);
    } else {
      PreferenciasController.instance.limpar();
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            jaLogado ? 'Preferências salvas!' : 'Conta criada com sucesso!',
          ),
        ),
      );

    if (jaLogado) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, 'home_usuario', (_) => false);
    }
  }

  void _continuar() => _finalizar(comPreferencias: true);

  void _pular() {
    if (_jaLogado) {
      // quem já tem conta só volta, sem apagar as preferências
      Navigator.pop(context);
      return;
    }
    _finalizar(comPreferencias: false);
  }

  @override
  Widget build(BuildContext context) {
    final podeContinuar = _selecionadas.length >= _minimoSelecionado;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _carregando ? null : _pular,
                  child: Text(_jaLogado ? 'Cancelar' : 'Pular'),
                ),
              ),

              const Text(
                'Escolha suas áreas de interesse',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              const Text(
                'Vamos personalizar seu feed com os serviços que mais interessam a você.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _areas.length,
                  itemBuilder: (context, index) {
                    final area = _areas[index];
                    return _CardArea(
                      area: area,
                      selecionada: _selecionadas.contains(area.nome),
                      onTap: () => _alternar(area.nome),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              Text(
                _selecionadas.isEmpty
                    ? 'Selecione pelo menos $_minimoSelecionado área'
                    : '${_selecionadas.length} selecionada(s)',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: (podeContinuar && !_carregando) ? _continuar : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  disabledBackgroundColor: Colors.grey.shade300,
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
                        'Continuar',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardArea extends StatelessWidget {
  final AreaServico area;
  final bool selecionada;
  final VoidCallback onTap;

  const _CardArea({
    required this.area,
    required this.selecionada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final corFundo = selecionada ? Colors.black : Colors.white;
    final corConteudo = selecionada ? Colors.white : Colors.black87;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: corFundo,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selecionada ? Colors.black : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(area.icone, size: 32, color: corConteudo),
                  const SizedBox(height: 8),
                  Text(
                    area.nome,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: corConteudo,
                    ),
                  ),
                ],
              ),
            ),
            if (selecionada)
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.check_circle, size: 20, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}