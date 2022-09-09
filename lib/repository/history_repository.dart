import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/history_model.dart';
import 'repository_interface.dart';

class HistoryRepository implements Repository<HistoryModel> {
  final collection = FirebaseFirestore.instance.collection('history');

  @override
  Future<HistoryModel> create(HistoryModel item) async {
    await collection.add(item.toJson());
    return item;
  }

  @override
  Future<bool> delete(String id) async {
    await collection.doc(id).delete().catchError(
          (e) => false,
        );
    return true;
  }

  @override
  Future<HistoryModel> getOne(String id) async {
    final snapshot = await collection.doc(id).get();
    return HistoryModel.fromJson(snapshot.data()!);
  }

  @override
  Future<List<HistoryModel>> list() async {
    final docs = await collection.get();
    return docs.docs.map((doc) {
      return HistoryModel.fromJson(doc.data());
    }).toList();
  }

  @override
  Future<bool> update(String id, HistoryModel item) async {
    await collection.doc(id).update(item.toJson()).catchError((_) => false);
    return true;
  }

  @override
  Future<String> getDocumentID(String uid) async {
    final docs = await collection.get();
    return docs.docs.firstWhere((doc) => doc.data()['uid'] == uid).id;
  }
}
