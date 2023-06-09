import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart.dart';
import 'drawer.dart';
import 'product_details.dart';
import 'search.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    refreshController.refreshCompleted();
  }

  //instantiate Firebase Firestore for the whole home page
  var firestoreInstance = FirebaseFirestore.instance;

  //this is the position of the dots  that form the images slider
  var _dotPosition = 0;
  //fetch the carousel imgs in form of a list
  List<String> _CarouselImages = [];

  //fetch carousel images from the firebase db
  fetchCarouselImages() {
    asyncFetchCorouselImages();
  }

  asyncFetchCorouselImages() async {
    QuerySnapshot qn =
        await firestoreInstance.collection("carousel-images").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _CarouselImages.add(qn.docs[i]["img-path"]);
      }
    });
    return qn.docs;
  }

  @override
  void initState() {
    super.initState();
    fetchCarouselImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrower(),
      appBar: AppBar(
        title: SizedBox(
          width: 90,
          child: Image.asset(
            "assets/images/icon.png",
            height: 35,
            width: 35,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.search_circle_fill,
                color: Colors.orange),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Search()),
              );
            },
          ),
          IconButton(
            icon:
                const Icon(CupertinoIcons.shopping_cart, color: Colors.orange),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Savedproductss()),
              );
            },
          ),
        ],
        titleSpacing: 00.0,
        centerTitle: false,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        elevation: 0.00,
        backgroundColor: Colors.black87,
      ),
      body: SmartRefresher(
        controller: refreshController,
        onRefresh: _onRefresh,
        header: const WaterDropHeader(waterDropColor: Colors.orange),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 3.5,
                child: CarouselSlider(
                    items: _CarouselImages.map((item) => Padding(
                          padding: const EdgeInsets.only(left: 3, right: 3),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                    topLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0)),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                  )
                                ],
                                image: DecorationImage(
                                    image: NetworkImage(item),
                                    fit: BoxFit.cover)),
                          ),
                        )).toList(),
                    options: CarouselOptions(
                        height: 400,
                        viewportFraction: 0.75,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 4),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 1500),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        onPageChanged: (val, carouselPageChangedReason) {
                          setState(() {
                            //to be coded
                            _dotPosition = val;
                          });
                        })),
              ),
              const SizedBox(
                height: 10,
              ),
              DotsIndicator(
                dotsCount: _CarouselImages.isEmpty ? 1 : _CarouselImages.length,
                position: _dotPosition.toDouble(),
                decorator: const DotsDecorator(
                    color: Colors.grey,
                    activeColor: Colors.redAccent,
                    spacing: EdgeInsets.all(2),
                    activeSize: Size(8, 8),
                    size: Size(6, 6)),
              ),
              const Text("Available Products:",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'Luzern',
                  )),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("products")
                    .snapshots(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: GridTile(
                                        child: GestureDetector(
                                            onTap: () {
                                              final product = snapshot
                                                  .data!.docs[index]
                                                  .data();

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductDetails(
                                                            product: product,
                                                          )));
                                            },
                                            child: CachedNetworkImage(
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      LinearProgressIndicator(
                                                value:
                                                    downloadProgress.progress,
                                                color: Colors.orange,
                                                backgroundColor: Colors.black12,
                                              ),
                                              errorWidget: ((context, url,
                                                      error) =>
                                                  Image.asset(
                                                      'assets/images/placeholder.png')),
                                              imageUrl: snapshot
                                                      .data!.docs[index]
                                                      .data()["product-img"] ??
                                                  '',
                                            )),
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!.docs[index]
                                              .data()["product-name"] ??
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
                                          "UGX ${snapshot.data!.docs[index].data()["product-new-price"] ?? ''}",
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 1.0,
                        mainAxisSpacing: 2,
                        mainAxisExtent: 200,
                      ),
                    );
                  } else {
                    return const Center(
                      child: LinearProgressIndicator(
                        minHeight: 4.0,
                        backgroundColor: Colors.black,
                        color: Colors.orange,
                      ),
                    );
                  }
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
