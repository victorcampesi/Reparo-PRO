import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reparo_pro/controller/sessao_controller.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  User? get usuarioAtual => _auth.currentUser;

  String _mensagem(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'weak-password':
        return 'Senha fraca. Use pelo menos 6 caracteres.';
      case 'network-request-failed':
        return 'Sem conexão com a internet.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente mais tarde.';
      case 'user-disabled':
        return 'Esta conta foi desativada.';
      default:
        return 'Não foi possível autenticar. Tente novamente. (${e.code})';
    }
  }

  Future<String?> login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _mensagem(e);
    } catch (_) {
      return 'Erro inesperado. Tente novamente.';
    }
  }

  Future<TipoConta?> tipoDoUsuario() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    final doc = await _db.collection('usuarios').doc(uid).get();
    final nome = doc.data()?['tipo'] as String?;
    for (final t in TipoConta.values) {
      if (t.name == nome) return t;
    }
    return null;
  }

  Future<String?> salvarPreferencias(Set<String> preferencias) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return 'Você precisa estar logado.';
    try {
      await _db.collection('usuarios').doc(uid).update({
        'preferencias': preferencias.toList(),
      });
      return null;
    } on FirebaseException catch (_) {
      return 'Não foi possível salvar suas preferências.';
    } catch (_) {
      return 'Erro inesperado. Tente novamente.';
    }
  }

  Future<String?> registrar({
    required String email,
    required String senha,
    required Map<String, dynamic> dados,
  }) async {
    UserCredential? cred;
    try {
      cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );
      await _db.collection('usuarios').doc(cred.user!.uid).set({
        ...dados,
        'email': email.trim(),
        'criadoEm': FieldValue.serverTimestamp(),
      });
      return null;
    } on FirebaseAuthException catch (e) {
      return _mensagem(e);
    } on FirebaseException catch (_) {
      await cred?.user?.delete();
      return 'Não foi possível salvar seus dados. Tente novamente.';
    } catch (_) {
      await cred?.user?.delete();
      return 'Erro inesperado. Tente novamente.';
    }
  }

  Future<String?> recuperarSenha(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      return _mensagem(e);
    } catch (_) {
      return 'Erro inesperado. Tente novamente.';
    }
  }

  Future<void> sair() async {
    SessaoController.instance.limpar();
    await _auth.signOut();
  }
}
