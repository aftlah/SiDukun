import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/penduduk.dart';

class FirestoreService {
  final CollectionReference penduduk =
      FirebaseFirestore.instance.collection('DataPenduduk');

  Future<void> addPenduduk(Penduduk penduduk) async {
    await this.penduduk.add(penduduk.toMap());
  }

  Future<void> updatePenduduk(Penduduk penduduk) async {
    await this.penduduk.doc(penduduk.id).update(penduduk.toMap());
  }

  Future<void> deletePenduduk(String id) async {
    await penduduk.doc(id).delete();
  }

  Stream<List<Penduduk>> getPenduduk() {
    return penduduk.snapshots().map((snapshot) => snapshot.docs
        .map((doc) =>
            Penduduk.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }
}
