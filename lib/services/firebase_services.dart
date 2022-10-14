import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  CollectionReference mainCategory =
      FirebaseFirestore.instance.collection('mainCategory');

  CollectionReference subCategory =
      FirebaseFirestore.instance.collection('subCategory');

  Future<void> saveCategory({
    CollectionReference? reference,
    Map<String, dynamic>? data,
    String? docName,
  }) {
    return reference!.doc(docName).set(data);
  }
}
