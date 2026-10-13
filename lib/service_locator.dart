import 'package:get_it/get_it.dart';
import 'package:reparo_pro/controller/cadastro_usuario_controller.dart';
import 'package:reparo_pro/controller/cadastro_empresa_controller.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<CadastroUsuarioController>(
    () => CadastroUsuarioController(),
  );
  getIt.registerLazySingleton<CadastroEmpresaController>(
    () => CadastroEmpresaController(),
  );
}