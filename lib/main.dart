import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/material.dart';
import 'package:reparo_pro/view/inicio_view.dart';
import 'package:reparo_pro/view/login_view.dart';

import 'view/cadastro_usuario_view.dart';
import 'view/perfil_view.dart';
import 'view/recuperar_senha_view.dart';
import 'view/sobre_view.dart';


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
        'sobre': (context) => const SobreView(),
        'login':(context) => const LoginView(),
      },

      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => InicioView(),
        );
      },
    );
  }
}
