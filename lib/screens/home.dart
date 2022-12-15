import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //List the product images
  List _products = [];

  //this is the position of the dots  that form the images slider
  var _dotPosition = 0;
  //fetch the carousel imgs in form of a list
  List<String> _CarouselImages = [];

  //fetch carousel images from the firebase db
  fetchCarouselImages() async {
    var firestoreInstance = FirebaseFirestore.instance;
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
    fetchCarouselImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrower(),
      appBar: AppBar(
        title: SizedBox(
          width: 90,
          child: Image.asset("assets/images/logo.png"),
        ),
        titleSpacing: 00.0,
        centerTitle: false,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        elevation: 0.00,
        backgroundColor: Colors.black87,
      ),
      body: Padding(
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
                              image: DecorationImage(
                                  image: NetworkImage(item),
                                  fit: BoxFit.cover)),
                        ),
                      )).toList(),
                  options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
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
          ],
        ),
      ),
    );
  }
}
