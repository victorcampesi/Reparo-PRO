import 'package:flutter/material.dart';
import 'package:reparo_pro/controller/cadastro_usuario_controller.dart';
import 'package:reparo_pro/service_locator.dart';

class ServicoContratado {
  final String titulo;
  final String prestador;
  final String data;
  final String status;

  const ServicoContratado({
    required this.titulo,
    required this.prestador,
    required this.data,
    required this.status,
  });
}

class PerfilUsuarioView extends StatelessWidget {
  final List<ServicoContratado> servicos;

  const PerfilUsuarioView({
    super.key,
    this.servicos = const [],
  });

  // Dados do cadastro, lidos do controller compartilhado
  CadastroUsuarioController get _cadastro =>
      getIt<CadastroUsuarioController>();

  String get nome => _cadastro.nome.isEmpty ? 'Usuário' : _cadastro.nome;

  String get email =>
      _cadastro.email.isEmpty ? 'Não informado' : _cadastro.email;

  String get telefone => _cadastro.telefone.isEmpty
      ? 'Não informado'
      : _cadastro.telefoneFormatado;

  String get cpf =>
      _cadastro.cpf.isEmpty ? 'Não informado' : _cadastro.cpfFormatado;

  String get cidade =>
      _cadastro.cidade.isEmpty ? 'Não informado' : _cadastro.cidade;

  String get _iniciais {
    final partes =
        nome.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
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

  Widget _cardServico(ServicoContratado s) {
    final concluido = s.status == 'Concluído';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: const Icon(Icons.handyman_outlined, size: 32),
        title: Text(
          s.titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text('${s.prestador}\n${s.data}'),
        ),
        isThreeLine: true,
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: concluido ? Colors.green.shade100 : Colors.orange.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(s.status, style: const TextStyle(fontSize: 12)),
        ),
      ),
    );
  }

  Widget _abaDados(BuildContext context) {
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
            nome,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text('Cliente', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),

          Card(
            child: Column(
              children: [
                _itemDado(Icons.email_outlined, 'E-mail', email),
                const Divider(height: 1),
                _itemDado(Icons.phone_outlined, 'Telefone', telefone),
                const Divider(height: 1),
                _itemDado(Icons.badge_outlined, 'CPF', cpf),
                const Divider(height: 1),
                _itemDado(Icons.location_city_outlined, 'Cidade', cidade),
              ],
            ),
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'editar_perfil');
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

  Widget _abaServicos() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Serviços contratados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          if (servicos.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'Você ainda não contratou nenhum serviço.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ...servicos.map(_cardServico),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
   return ListenableBuilder(
    listenable: _cadastro,
    builder: (context, _) => DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Meu perfil'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person_outline), text: 'Dados'),
              Tab(icon: Icon(Icons.history), text: 'Serviços'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              _abaDados(context),
              _abaServicos(),
            ],
          ),
        ),
      ),
    ),
    );
  }
}