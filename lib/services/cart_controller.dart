import 'package:cloud_firestore/cloud_firestore.dart';

class CartController {
  String id;
  CartController({required this.id});
  totalPrice() async {
    QuerySnapshot items = await FirebaseFirestore.instance
        .collection('Cart')
        .doc(id)
        .collection('PersonalCart')
        .get();
    int total = 0;
    dynamic ithProduct;
    final products = items.docs.map((doc) => doc.data() as Map).toList();
    for (int i = 0; i < products.length; i++) {
      ithProduct = products[i];
      total += ithProduct['product-new-price'] as int;
    }
    return total;
  }
}
