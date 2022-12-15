import 'package:flutter/material.dart';

import 'drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
      body: const Text(
        "Welcome to the Home Screen!",
      ),
    );
  }
}
