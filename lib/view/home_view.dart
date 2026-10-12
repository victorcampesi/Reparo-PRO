import 'package:flutter/material.dart';
import 'package:reparo_pro/controller/preferencias_controller.dart';
import 'perfil_usuario_view.dart';

class Postagem {
  final String autor;
  final String usuario;
  final bool empresa;
  final String area;
  final String texto;
  final String tempo;
  final int comentarios;
  final int curtidas;

  const Postagem({
    required this.autor,
    required this.usuario,
    required this.empresa,
    required this.area,
    required this.texto,
    required this.tempo,
    required this.comentarios,
    required this.curtidas,
  });
}

const List<Postagem> _postagens = [
  Postagem(
    autor: 'Carlos Eletricista',
    usuario: '@carlos.eletrica',
    empresa: false,
    area: 'Elétrica',
    texto:
        'Disjuntor desarmando toda hora? Pode ser sobrecarga ou fuga de corrente. '
        'Não insista em religar, chame um profissional. Atendo hoje na região!',
    tempo: '12 min',
    comentarios: 8,
    curtidas: 42,
  ),
  Postagem(
    autor: 'HidroFix Desentupidora',
    usuario: '@hidrofix',
    empresa: true,
    area: 'Hidráulica',
    texto:
        'Vazamento escondido na parede? Usamos detector acústico, sem quebrar '
        'nada. Orçamento grátis e atendimento 24h. 💧',
    tempo: '35 min',
    comentarios: 15,
    curtidas: 97,
  ),
  Postagem(
    autor: 'Marina Pinturas',
    usuario: '@marina.pinta',
    empresa: false,
    area: 'Pintura',
    texto:
        'Antes e depois de uma sala de 20m². Dica: sempre aplique selador antes '
        'da tinta, a diferença no acabamento é enorme. 🎨',
    tempo: '1 h',
    comentarios: 23,
    curtidas: 184,
  ),
  Postagem(
    autor: 'Madeira & Arte',
    usuario: '@madeiraearte',
    empresa: true,
    area: 'Marcenaria',
    texto:
        'Armários planejados sob medida com 10% de desconto neste mês. '
        'Agende uma visita técnica sem compromisso.',
    tempo: '2 h',
    comentarios: 6,
    curtidas: 58,
  ),
  Postagem(
    autor: 'Climatiza Express',
    usuario: '@climatizaexpress',
    empresa: true,
    area: 'Ar-condicionado',
    texto:
        'Limpeza de ar-condicionado a cada 6 meses evita mau cheiro e reduz '
        'a conta de luz. Já agendou a sua? ❄️',
    tempo: '2 h',
    comentarios: 11,
    curtidas: 73,
  ),
  Postagem(
    autor: 'Jorge Reparos',
    usuario: '@jorge.reparos',
    empresa: false,
    area: 'Eletrodomésticos',
    texto:
        'Máquina de lavar não centrifuga? Na maioria dos casos é a correia ou '
        'o sensor de tampa. Conserto na hora, com garantia.',
    tempo: '3 h',
    comentarios: 9,
    curtidas: 36,
  ),
  Postagem(
    autor: 'TechSolve Informática',
    usuario: '@techsolve',
    empresa: true,
    area: 'Informática',
    texto:
        'Notebook lento? Antes de comprar outro, veja se um SSD e mais RAM '
        'resolvem. Fazemos diagnóstico gratuito. 💻',
    tempo: '3 h',
    comentarios: 31,
    curtidas: 210,
  ),
  Postagem(
    autor: 'Rafa Celulares',
    usuario: '@rafa.cel',
    empresa: false,
    area: 'Celulares',
    texto:
        'Troca de tela em 40 minutos, com peça de qualidade e 90 dias de '
        'garantia. Faço também troca de bateria. 📱',
    tempo: '4 h',
    comentarios: 14,
    curtidas: 89,
  ),
  Postagem(
    autor: 'Construtora Alicerce',
    usuario: '@alicerce.reformas',
    empresa: true,
    area: 'Reformas',
    texto:
        'Reforma de banheiro completa em até 10 dias úteis. Veja o projeto '
        'finalizado no nosso portfólio e peça seu orçamento.',
    tempo: '5 h',
    comentarios: 19,
    curtidas: 132,
  ),
  Postagem(
    autor: 'Chaveiro 24h do Zé',
    usuario: '@zechaveiro',
    empresa: false,
    area: 'Chaveiro',
    texto:
        'Trancado para fora de casa? Abro portas sem danificar a fechadura. '
        'Chego em até 20 minutos. 🔑',
    tempo: '5 h',
    comentarios: 4,
    curtidas: 27,
  ),
  Postagem(
    autor: 'Verde Vida Jardins',
    usuario: '@verdevida',
    empresa: true,
    area: 'Jardinagem',
    texto:
        'Manutenção mensal de jardins residenciais e condomínios. Poda, '
        'adubação e paisagismo em um só pacote. 🌿',
    tempo: '6 h',
    comentarios: 7,
    curtidas: 61,
  ),
  Postagem(
    autor: 'Dona Lúcia Limpezas',
    usuario: '@lucialimpeza',
    empresa: false,
    area: 'Limpeza',
    texto:
        'Faxina pós-obra com equipamento profissional. Deixo tudo pronto para '
        'você só se mudar. Agenda aberta para a próxima semana.',
    tempo: '7 h',
    comentarios: 5,
    curtidas: 33,
  ),
  Postagem(
    autor: 'Auto Center Silva',
    usuario: '@autosilva',
    empresa: true,
    area: 'Mecânica',
    texto:
        'Barulho na suspensão ao passar em lombadas? Faça o check-up '
        'completo: scanner, freios e alinhamento com preço fechado. 🚗',
    tempo: '8 h',
    comentarios: 12,
    curtidas: 77,
  ),
  Postagem(
    autor: 'Vidros Transparência',
    usuario: '@vidrostransp',
    empresa: true,
    area: 'Vidraçaria',
    texto:
        'Box de banheiro, espelhos e janelas sob medida. Instalação no mesmo '
        'dia para itens em estoque.',
    tempo: '9 h',
    comentarios: 3,
    curtidas: 29,
  ),
];

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _controller = PreferenciasController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
  automaticallyImplyLeading: false,
  title: Text('Reparo PRO', style: TextStyle(fontWeight: FontWeight.bold)),
  actions: [
    IconButton(
      icon: Icon(Icons.tune),
      tooltip: 'Áreas de interesse',
      onPressed: () => Navigator.pushNamed(context, 'preferencias'),
    ),
    IconButton(
      icon: Icon(Icons.account_circle_outlined),
      tooltip: 'Meu perfil',
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PerfilUsuarioView()),
      ),
    ),
  ],
),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Pesquise profissionais ou seu problema',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Reconstrói automaticamente quando as preferências mudam
              Expanded(
                child: ListenableBuilder(
                  listenable: _controller,
                  builder: (context, _) {
                    if (!_controller.temAreas) {
                      return _EstadoInicial();
                    }

                    final areas = _controller.areas;
                    final posts = _postagens
                        .where((p) => areas.contains(p.area))
                        .toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FiltroAreas(areas: areas.toList()),
                        SizedBox(height: 8),
                        Text(
                          'Sugestões para você',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Expanded(
                          child: posts.isEmpty
                              ? Center(
                                  child: Text(
                                    'Ainda não há postagens nas suas áreas.',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: posts.length,
                                  separatorBuilder: (_, _) =>
                                      Divider(height: 1),
                                  itemBuilder: (context, i) =>
                                      _PostCard(postagem: posts[i]),
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Mostrado quando o usuário pulou a escolha de áreas
class _EstadoInicial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.travel_explore, size: 72, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'Aqui começa a sua navegação',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Comece pesquisando por profissionais ou descrevendo o seu '
              'problema na barra acima.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, 'preferencias');
              },
              icon: Icon(Icons.tune),
              label: Text('Escolher áreas de interesse'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Linha horizontal com as áreas escolhidas
class _FiltroAreas extends StatelessWidget {
  final List<String> areas;

  const _FiltroAreas({required this.areas});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: areas.length,
        separatorBuilder: (_, _) => SizedBox(width: 8),
        itemBuilder: (context, i) => Chip(
          label: Text(areas[i], style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          side: BorderSide.none,
        ),
      ),
    );
  }
}

class _PostCard extends StatefulWidget {
  final Postagem postagem;

  const _PostCard({required this.postagem});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  bool _curtido = false;

  String get _iniciais {
    final partes = widget.postagem.autor.split(' ');
    return partes.take(2).map((p) => p[0]).join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.postagem;
    final curtidas = p.curtidas + (_curtido ? 1 : 0);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.black,
            child: Text(
              _iniciais,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        p.autor,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (p.empresa) ...[
                      SizedBox(width: 4),
                      Icon(Icons.verified, size: 16, color: Colors.blueGrey),
                    ],
                    SizedBox(width: 6),
                    Text(
                      '· ${p.tempo}',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
                Text(
                  p.usuario,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                SizedBox(height: 8),
                Text(p.texto, style: TextStyle(fontSize: 15, height: 1.35)),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${p.area} · ${p.empresa ? 'Empresa' : 'Autônomo'}',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _Acao(
                      icone: Icons.chat_bubble_outline,
                      texto: '${p.comentarios}',
                      onTap: () {},
                    ),
                    _Acao(
                      icone: _curtido ? Icons.favorite : Icons.favorite_border,
                      texto: '$curtidas',
                      cor: _curtido ? Colors.red : null,
                      onTap: () => setState(() => _curtido = !_curtido),
                    ),
                    _Acao(
                      icone: Icons.bookmark_border,
                      texto: 'Salvar',
                      onTap: () {},
                    ),
                    _Acao(
                      icone: Icons.share_outlined,
                      texto: '',
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Acao extends StatelessWidget {
  final IconData icone;
  final String texto;
  final Color? cor;
  final VoidCallback onTap;

  const _Acao({
    required this.icone,
    required this.texto,
    required this.onTap,
    this.cor,
  });

  @override
  Widget build(BuildContext context) {
    final corFinal = cor ?? Colors.grey.shade600;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Row(
          children: [
            Icon(icone, size: 19, color: corFinal),
            if (texto.isNotEmpty) ...[
              SizedBox(width: 4),
              Text(texto, style: TextStyle(fontSize: 13, color: corFinal)),
            ],
          ],
        ),
      ),
    );
  }
}