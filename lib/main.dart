import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/material.dart';
import 'package:reparo_pro/view/cadastro_empresa_view.dart';
import 'package:reparo_pro/view/inicio_view.dart';
import 'package:reparo_pro/view/login_view.dart';
import 'package:reparo_pro/view/saber_mais_view.dart';
import 'package:reparo_pro/view/tipo_prestador_view.dart';
import 'package:reparo_pro/view/tipo_usuario_view.dart';

import 'view/cadastro_usuario_view.dart';
import 'view/perfil_view.dart';
import 'view/recuperar_senha_view.dart';


void main() {
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
        'perfil': (context) => const PerfilView(),
        'recuperar_senha': (context) => const RecuperarSenhaView(),
        'login':(context) => const LoginView(),
        'saber':(context) => const SaberMaisView(),
        'tipo_usuario':(context) => const TipoUsuarioView(),
        'tipo_prestador':(context) => const TipoPrestadorView(),
        'cadastro_empresa':(context) => const CadastroEmpresaView()
      },

      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => InicioView(),
        );
      },
    );
  }
}
