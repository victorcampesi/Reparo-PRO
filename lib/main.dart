import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/material.dart';
import 'package:reparo_pro/service_locator.dart';
import 'package:reparo_pro/view/cadastro_autonomo_view.dart';
import 'package:reparo_pro/view/cadastro_empresa_view.dart';
import 'package:reparo_pro/view/editar_perfil_empresa_view.dart';
import 'package:reparo_pro/view/editar_perfil_view.dart';
import 'package:reparo_pro/view/home_empresa_view.dart';
import 'package:reparo_pro/view/home_prestador_view.dart';
import 'package:reparo_pro/view/home_view.dart';
import 'package:reparo_pro/view/inicio_view.dart';
import 'package:reparo_pro/view/login_view.dart';
import 'package:reparo_pro/view/perfil_empresa_view.dart';
import 'package:reparo_pro/view/perfil_prestador_view.dart';
import 'package:reparo_pro/view/perfil_usuario_view.dart';
import 'package:reparo_pro/view/perguntas_empresa_view.dart';
import 'package:reparo_pro/view/perguntas_prestador_view.dart';
import 'package:reparo_pro/view/preferencias_view.dart';
import 'package:reparo_pro/view/saber_mais_view.dart';
import 'package:reparo_pro/view/tipo_prestador_view.dart';
import 'package:reparo_pro/view/tipo_usuario_view.dart';


import 'view/cadastro_usuario_view.dart';
import 'view/recuperar_senha_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(DevicePreview(builder: (context) => const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reparo PRO',

      //
      // ROTAS
      //
      initialRoute: 'inicio',
      routes: {
        'inicio': (context) => const InicioView(),
        'cadastro_usuario': (context) => const CadastroUsuarioView(),
        'cadastro_empresa': (context) => const CadastroEmpresaView(),
        'cadastro_autonomo': (context) => const CadastroAutonomoView(),
        'perfil_prestador': (context) => const PerfilPrestadorView(),
        'perfil_usuario': (context) => const PerfilUsuarioView(),
        'perfil_empresa':(context) => const PerfilEmpresaView(),
        'recuperar_senha': (context) => const RecuperarSenhaView(),
        'login': (context) => const LoginView(),
        'saber': (context) => const SaberMaisView(),
        'tipo_usuario': (context) => const TipoUsuarioView(),
        'tipo_prestador': (context) => const TipoPrestadorView(),
        'perguntas_prestador': (context) => const PerguntasPrestadorView(),
        'perguntas_empresa': (context) => const PerguntasEmpresaView(),
        'home_prestador': (context) => const HomePrestadorView(),
        'home_usuario': (context) => const HomeView(),
        'home_empresa':(context) => const HomeEmpresaView(),
        'preferencias': (context) => const PreferenciasView(),
        'editar_perfil': (context) => const EditarPerfilView(),
        'editar_perfil_prestador': (context) => const EditarPerfilView(profissional: true),
        'editar_perfil_empresa': (context) => const EditarPerfilEmpresaView(),
      },

      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => InicioView(),
        );
      },
    );
  }
}