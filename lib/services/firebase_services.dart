import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  CollectionReference mainCategory =
      FirebaseFirestore.instance.collection('mainCategory');

  CollectionReference subCategory =
      FirebaseFirestore.instance.collection('subCategory');

  CollectionReference vendor = FirebaseFirestore.instance.collection('vendor');

  Future<void> saveCategory({
    CollectionReference? reference,
    Map<String, dynamic>? data,
    String? docName,
  }) {
    return reference!.doc(docName).set(data);
  }

  Future<void> updateData({
    CollectionReference? reference,
    Map<String, dynamic>? data,
    String? docName,
  }) {
    return reference!.doc(docName).update(data!);
  }
}
