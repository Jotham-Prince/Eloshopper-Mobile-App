import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future deleteCart(String docId) async {
    try {
      // await firestore.collection('Cart').doc(docId).delete();
      debugPrint(
          "==================Am aboout to delete the stuff============================");
      await firestore
          .collection('Cart')
          .doc(docId)
          .collection('PersonalCart')
          .doc('product-name')
          .delete();
      debugPrint(
          '===================successfull deletion========================================');
    } catch (e) {
      print(e);
    }
  }
}
