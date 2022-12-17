import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'product_details.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchtf = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('searchString', arrayContains: searchtf.text)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 00.0,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        elevation: 0.00,
        backgroundColor: Colors.black87,
        title: Container(
          padding: const EdgeInsets.only(left: 20, right: 10),
          child: TextField(
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              fillColor: Colors.grey,
              focusedBorder: UnderlineInputBorder(
                // borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(
                  color: Colors.orange,
                ),
              ),
              suffixIcon: InkWell(
                child: Icon(Icons.search, color: Colors.orange),
              ),
              contentPadding: EdgeInsets.all(15.0),
              hintText: 'Search for products...',
            ),
            controller: searchtf,
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
      ),
      body: StreamBuilder(
        stream: productsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something is wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator(
              minHeight: 4.0,
              backgroundColor: Colors.black,
              color: Colors.orange,
            );
          }
          return GridView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, index) {
              return Card(
                child: Container(
                  height: 290,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.all(1),
                  padding: const EdgeInsets.all(1),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: GridTile(
                              child: GestureDetector(
                                onTap: () {
                                  dynamic product =
                                      snapshot.data!.docs[index].data();
                                  // snapshot.data!.docChanges[index].data();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductDetails(
                                                product: product,
                                              )));
                                },
                                child: Image.network(
                                  snapshot.data!.docChanges[index]
                                          .doc['product-img'] ??
                                      'https://firebasestorage.googleapis.com/v0/b/eshopper-ef8a2.appspot.com/o/product-images%2Fapple-watch.jpeg?alt=media&token=756d37d3-7f1b-4339-874e-b47e5d3df95f',
                                  // fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            snapshot.data!.docChanges[index]
                                    .doc['product-name'] ??
                                '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Josefin',
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "UGX ${snapshot.data!.docChanges[index].doc['product-new-price'] ?? ''}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: 'Luzern',
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: 1.0,
              mainAxisSpacing: 2,
              mainAxisExtent: 200,
            ),
          );
        },
      ),
    );
  }
}
