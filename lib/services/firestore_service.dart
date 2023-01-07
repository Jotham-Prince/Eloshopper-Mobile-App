import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future deleteCart(String docId) async {
    try {
      // await firestore.collection('Cart').doc(docId).delete();
      print(
          "==================Am aboout to delete the stuff============================");
      await firestore
          .collection('Cart')
          .doc(docId)
          .collection('PersonalCart')
          .doc('product-name')
          .delete();
      print(
          '===================successfull deletion========================================');
    } catch (e) {
      print(e);
    }
  }
}
