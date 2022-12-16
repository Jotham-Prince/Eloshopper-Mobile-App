// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class ProductDetails extends StatelessWidget {
  final product;
  const ProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    String? id = user?.uid;
    if (id == null) {
      return const Center(child: CircularProgressIndicator());
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: size.height * 0.5,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(product['product-img']),
                      fit: BoxFit.contain)),
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon:
                              const Icon(CupertinoIcons.arrow_left_circle_fill),
                          color: Colors.black),
                      IconButton(
                          onPressed: () {
                            //route to cart
                          },
                          icon: const Icon(Icons.shopping_basket_outlined),
                          color: Colors.black)
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: size.height * 0.45),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      child: Container(
                        width: 150,
                        height: 7,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      product["product-name"],
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          color: Colors.black,
                          height: 1.5,
                          fontSize: 30,
                          fontFamily: 'Luzern'),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Order Quantities:",
                      style: const TextStyle(
                          color: Colors.black87,
                          height: 1.5,
                          fontSize: 16,
                          fontFamily: 'Sarasori'),
                    ),
                    Text(
                      "in stock",
                      style: const TextStyle(
                        color: Colors.grey,
                        height: 1.5,
                        fontSize: 16,
                        fontFamily: 'Sarasori',
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Description:",
                      style: const TextStyle(
                          color: Colors.black87,
                          height: 1.5,
                          fontSize: 16,
                          fontFamily: 'Sarasori'),
                    ),
                    Text(
                      product["product-description"],
                      style: const TextStyle(
                        color: Colors.grey,
                        height: 1.5,
                        fontSize: 16,
                        fontFamily: 'Sarasori',
                      ),
                    ),
                    Text(
                      "Waranty:",
                      style: const TextStyle(
                        color: Colors.black,
                        height: 1.5,
                        fontSize: 16,
                        fontFamily: 'Sarasori',
                      ),
                    ),
                    Text(
                      "Warranty",
                      style: const TextStyle(
                        color: Colors.grey,
                        height: 1.5,
                        fontSize: 16,
                        fontFamily: 'Sarasori',
                      ),
                    ),
                    Text(
                      "Return Policy:",
                      style: const TextStyle(
                        color: Colors.black,
                        height: 1.5,
                        fontSize: 16,
                        fontFamily: 'Sarasori',
                      ),
                    ),
                    Text(
                      'return policy',
                      style: const TextStyle(
                        color: Colors.grey,
                        height: 1.5,
                        fontSize: 16,
                        fontFamily: 'Sarasori',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Original Price:",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                fontFamily: 'Sarasori'),
                          ),
                          Text("UGX ${product['product-original-price']}",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Sarasori')),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Discount Price:',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                fontFamily: 'Sarasori'),
                          ),
                          Text(
                            'UGX ${product['product-new-price']}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Sarasori'),
                          )
                        ],
                      ),
                    ]),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 50.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(16.0),
                        shadowColor: Colors.orange,
                        color: Colors.black,
                        elevation: 7.0,
                        child: InkWell(
                          onTap: () {
                            //add to the cart
                            FirebaseFirestore.instance
                                .collection('Cart')
                                .doc(id)
                                .collection('PersonalCart')
                                .doc(product['product-name'])
                                .set(product);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Succesfully added ${product['product-name']} to cart")));
                          },
                          child: const Center(
                            child: Text('Add to Cart',
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontFamily: 'Sarasori',
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
