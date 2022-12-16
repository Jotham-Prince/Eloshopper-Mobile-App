// ignore_for_file: prefer_const_constructors

// SHOPPING CART SCREEN LOGIC

// import the required packages

// import cupertino ios icons
import 'package:best_eshopper_application/services/cart_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
// import the main material ui flutter package
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// creation of a stateful widget because the carts info is going to be
// changing based on click events on different screens
class CartScreen extends StatefulWidget {
  // instantiate the class as stateful
  CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    String? id = user?.uid;
    if (id == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
        // the appbar
        appBar: AppBar(
          title: Text(
            'Shopping Cart',
            style: TextStyle(color: Colors.orange, fontFamily: 'Luzern'),
          ),
          centerTitle: true,
          backgroundColor: Colors.black87,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              // back to previous page when pressed
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.orange,
            ),
          ),
          actions: [
            // the payment methods section
            PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      const PopupMenuItem(
                        child: ListTile(
                          leading: Icon(
                            CupertinoIcons.shopping_cart,
                            color: Colors.orange,
                          ),
                          title: Text('Check out with Airtel Mobile Money'),
                        ),
                      ),
                      const PopupMenuItem(
                        child: ListTile(
                          leading: Icon(
                            CupertinoIcons.shopping_cart,
                            color: Colors.orange,
                          ),
                          title: Text('Check out with MTN Mobile Money'),
                        ),
                      ),
                      const PopupMenuItem(
                        child: ListTile(
                          leading: Icon(
                            CupertinoIcons.shopping_cart,
                            color: Colors.orange,
                          ),
                          title: Text('Check out with Bank Account'),
                        ),
                      ),
                      const PopupMenuItem(
                        child: ListTile(
                          leading: Icon(
                            CupertinoIcons.shopping_cart,
                            color: Colors.orange,
                          ),
                          title: Text('Check out with Paypal'),
                        ),
                      ),
                    ])
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Cart')
              .doc(id)
              .collection('PersonalCart')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: const CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Column(
                            children: List.generate(
                              snapshot.data!.docs.length,
                              (index) => Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 8, 16, 0),
                                child: Container(
                                  width: double.infinity,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white38,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Color(0x320E151B),
                                        offset: Offset(0, 1),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16, 8, 8, 8),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Hero(
                                          tag: 'Cart Image',
                                          transitionOnUserGestures: true,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            child: Image.network(
                                              snapshot.data!.docs[index]
                                                  .data()['product-img'],
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12, 0, 0, 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 0, 8),
                                                child: Text(
                                                  snapshot.data!.docs[index]
                                                      .data()['product-name'],
                                                  style: TextStyle(
                                                    fontFamily: 'Luzern',
                                                    color: Colors.black87,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '${snapshot.data!.docs[index].data()['product-new-price']}',
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontFamily: 'Luzern',
                                                    fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            CupertinoIcons.delete_solid,
                                            color: Colors.orange,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection('Cart')
                                                .doc(id)
                                                .collection('PersonalCart')
                                                .doc(
                                                    "${snapshot.data!.docs[index].data()['product-name']}")
                                                .delete();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total:",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                fontFamily: 'Sarasori'),
                          ),
                          Text("UGX ${CartController(id: id).totalPrice()}",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Sarasori')),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
                      child: SizedBox(
                        height: 50.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.orange,
                          color: Colors.black,
                          elevation: 7.0,
                          child: InkWell(
                            onTap: () async {
                              //make the order
                            },
                            child: const Center(
                              child: Text('Order items(On Cash Delivery)',
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontFamily: 'Sarasori',
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ));
  }
}
