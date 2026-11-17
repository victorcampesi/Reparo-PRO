import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SolicitacaoService {
  Stream<QuerySnapshot<Map<String, dynamic>>> listar() {
    final col = _colecao;
    if (col == null) return const Stream.empty();
    return col.orderBy('criadoEm', descending: true).snapshots();
  }

  CollectionReference<Map<String, dynamic>>? get _colecao {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    return FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('solicitacoes');
  }

  Future<String?> adicionar({
    required String titulo,
    required String descricao,
    required String categoria,
    required String urgencia,
    required DateTime prazo,
  }) async {
    final col = _colecao;
    if (col == null) return 'Você precisa estar logado.';

    try {
      await col
          .add({
            'titulo': titulo.trim(),
            'descricao': descricao.trim(),
            'categoria': categoria,
            'urgencia': urgencia,
            'prazo': Timestamp.fromDate(prazo),
            'status': 'aberta',
            'criadoEm': FieldValue.serverTimestamp(),
          })
          .timeout(const Duration(seconds: 10));
      return null;
    } on TimeoutException {
      return 'Sem resposta do servidor. Verifique sua conexão.';
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        return 'Sem permissão para salvar. Verifique as regras do Firestore.';
      }
      return 'Não foi possível salvar a solicitação.';
    } catch (_) {
      return 'Erro inesperado. Tente novamente.';
    }
  }
}
