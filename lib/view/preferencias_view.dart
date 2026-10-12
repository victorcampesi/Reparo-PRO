import 'package:flutter/material.dart';
import 'package:reparo_pro/controller/preferencias_controller.dart';

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

  void _alternar(String nome) {
    setState(() {
      if (_selecionadas.contains(nome)) {
        _selecionadas.remove(nome);
      } else {
        _selecionadas.add(nome);
      }
    });
  }

  void _continuar() {
    PreferenciasController.instance.definir(_selecionadas);
    Navigator.pushReplacementNamed(context, 'home_usuario');
  }

  void _pular() {
    PreferenciasController.instance.limpar();
    Navigator.pushReplacementNamed(context, 'home_usuario');
  }

  @override
  Widget build(BuildContext context) {
    final podeContinuar = _selecionadas.length >= _minimoSelecionado;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: _pular, child: Text('Pular')),
              ),

              Text(
                'Escolha suas áreas de interesse',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              Text(
                'Vamos personalizar seu feed com os serviços que mais interessam a você.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 24),

              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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

              SizedBox(height: 12),

              Text(
                _selecionadas.isEmpty
                    ? 'Selecione pelo menos $_minimoSelecionado área'
                    : '${_selecionadas.length} selecionada(s)',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 12),

              ElevatedButton(
                onPressed: podeContinuar ? _continuar : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  disabledBackgroundColor: Colors.grey.shade300,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
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
        duration: Duration(milliseconds: 200),
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
                  SizedBox(height: 8),
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
              Positioned(
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