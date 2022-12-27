import 'package:best_eshopper_application/screens/checkout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:best_eshopper_application/globals.dart' as globals;
import 'product_details.dart';

class Savedproductss extends StatelessWidget {
  const Savedproductss({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    String id = user!.uid;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30),
        child: SizedBox(
          height: 50.0,
          child: Material(
            borderRadius: BorderRadius.circular(20.0),
            shadowColor: Colors.orange,
            color: Colors.black,
            elevation: 7.0,
            child: InkWell(
              onTap: () async {
                final navigator = Navigator.of(context);
                QuerySnapshot<Map<String, dynamic>> cart =
                    await FirebaseFirestore.instance
                        .collection('Cart')
                        .doc(id)
                        .collection('PersonalCart')
                        .get();
                if (cart.docs.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("You have Nothing in your Cart")));
                } else {
                  final cartContents =
                      cart.docs.map((doc) => doc.data()).toList();
                  navigator.push(MaterialPageRoute(
                      builder: (
                    _,
                  ) =>
                          Checkout(
                            cartContents: cartContents,
                            total: globals.total,
                          )));
                }
              },
              child: const Center(
                child: Text('Checkout with cash',
                    style: TextStyle(
                        color: Colors.orange,
                        fontFamily: 'Sarasori',
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Ionicons.chevron_back),
          color: Colors.black,
        ),
        title: const Text('Shopping Cart'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Cart')
                    .doc(user.uid)
                    .collection('PersonalCart')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final products =
                        snapshot.data!.docs.map((doc) => doc.data()).toList();
                    dynamic ithProduct;
                    int total = 0;
                    for (int i = 0; i < products.length; i++) {
                      ithProduct = products[i];
                      total += ithProduct['product-new-price'] as int;
                    }
                    globals.total = total;
                    return Row(
                      children: [
                        const Text(
                          "Total:",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                              fontFamily: 'Sarasori'),
                        ),
                        Text("UGX $total",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Sarasori')),
                      ],
                    );
                  } else {
                    return const LinearProgressIndicator(
                      minHeight: 4.0,
                      backgroundColor: Colors.black,
                      color: Colors.orange,
                    );
                  }
                }),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Cart')
                  .doc(user.uid)
                  .collection('PersonalCart')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Products Yet",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 5.0,
                                    spreadRadius: 2.0,
                                    color: Colors.black12,
                                  ),
                                ]),
                            margin: const EdgeInsets.all(5.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                InkWell(
                                  onTap: () {
                                    final products =
                                        snapshot.data!.docs[index].data();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetails(
                                                  product: products,
                                                )));
                                  },
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0)),
                                    child: Image.network(
                                      snapshot.data!.docs[index]['product-img'],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.docs[index]
                                            ['product-name'],
                                        style: const TextStyle(
                                          fontFamily: 'Luzern',
                                          color: Colors.black87,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              top: 2.0, bottom: 2.0),
                                          child: Text(
                                              "UGX ${snapshot.data!.docs[index]['product-new-price']}")),
                                      IconButton(
                                        icon: const Icon(
                                          CupertinoIcons.delete_solid,
                                          color: Colors.orange,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('Cart')
                                              .doc(user.uid)
                                              .collection('PersonalCart')
                                              .doc(
                                                  "${snapshot.data!.docs[index].data()['product-name']}")
                                              .delete();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                } else {
                  return const LinearProgressIndicator(
                    minHeight: 4.0,
                    backgroundColor: Colors.black,
                    color: Colors.orange,
                  );
                }
              }),
          const SizedBox(
            height: 20,
          ),
        ],
      )),
    );
  }
}
