import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Repository<T> {
  Future<List<T>> list();
  Future<T> getOne(String id);
  Future<bool> update(String id, T item);
  Future<bool> delete(String id);
  Future<T> create(T item);
  Future<QueryDocumentSnapshot> getQueryDocumentSnapshot(String key);
}
