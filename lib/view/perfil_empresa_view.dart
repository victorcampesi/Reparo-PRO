import 'package:flutter/material.dart';
import 'package:reparo_pro/controller/cadastro_empresa_controller.dart';
import 'package:reparo_pro/service_locator.dart';

class PerfilEmpresaView extends StatelessWidget {
  const PerfilEmpresaView({super.key});

  CadastroEmpresaController get _empresa =>
      getIt<CadastroEmpresaController>();

  String _ou(String v) => v.isEmpty ? 'Não informado' : v;

  String get _nome => _empresa.nome.isEmpty ? 'Sua empresa' : _empresa.nome;

  String get _iniciais {
    final partes =
        _nome.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (partes.isEmpty) return '?';
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return (partes.first[0] + partes.last[0]).toUpperCase();
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(texto, style: const TextStyle(color: Colors.grey)),
    );
  }

  Widget _chips(Set<String> itens, String vazio) {
    if (itens.isEmpty) return _vazio(vazio);
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: itens
            .map(
              (a) => Chip(
                label: Text(a, style: const TextStyle(color: Colors.white)),
                backgroundColor: Colors.black,
                side: BorderSide.none,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _abaDados(BuildContext context) {
    final e = _empresa;
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
            _nome,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text('Empresa', style: TextStyle(color: Colors.grey)),
          if (e.descricao.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(e.descricao, textAlign: TextAlign.center),
          ],
          const SizedBox(height: 24),

          Card(
            child: Column(
              children: [
                _itemDado(
                  Icons.badge_outlined,
                  'CNPJ',
                  e.cnpj.isEmpty ? 'Não informado' : e.cnpjFormatado,
                ),
                const Divider(height: 1),
                  _itemDado(Icons.email_outlined, 'E-mail', _ou(e.email)),
                const Divider(height: 1),
                  _itemDado(
                 Icons.phone_outlined,
                    'Telefone',
                    e.telefone.isEmpty ? 'Não informado' : e.telefoneFormatado,
                  ),
                const Divider(height: 1),
                _itemDado(
                    Icons.location_city_outlined, 'Cidade', _ou(e.cidade)),
                const Divider(height: 1),
                _itemDado(Icons.link, 'Site ou Instagram', _ou(e.link)),
              ],
            ),
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'editar_perfil_empresa');
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

  Widget _abaAtuacao() {
    final e = _empresa;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titulo('Áreas de atuação'),
          _chips(e.areas, 'Nenhuma área informada.'),
          const SizedBox(height: 20),

          _titulo('Público atendido'),
          _chips(e.publicos, 'Nenhum público informado.'),
          const SizedBox(height: 20),

          _titulo('Operação'),
          Card(
            child: Column(
              children: [
                _itemDado(
                  Icons.groups_outlined,
                  'Funcionários',
                  _ou(e.funcionarios),
                ),
                const Divider(height: 1),
                _itemDado(
                  Icons.my_location,
                  'Raio de atendimento',
                  '${e.raioKm.round()} km',
                ),
                const Divider(height: 1),
                _itemDado(
                  Icons.timer_outlined,
                  'Tempo médio de resposta',
                  _ou(e.tempoResposta),
                ),
                const Divider(height: 1),
                _itemDado(
                  Icons.access_time,
                  'Atendimento 24 horas',
                  e.atende24h ? 'Sim' : 'Não',
                ),
                const Divider(height: 1),
                _itemDado(
                  Icons.request_quote_outlined,
                  'Orçamento gratuito',
                  e.orcamentoGratis ? 'Sim' : 'Não',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Perfil da empresa'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.storefront_outlined), text: 'Dados'),
              Tab(icon: Icon(Icons.handyman_outlined), text: 'Atuação'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              _abaDados(context),
              _abaAtuacao(),
            ],
          ),
        ),
      ),
    );
  }
}