import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import '../services/auth_service.dart';
import 'home.dart';

class AppDrower extends StatefulWidget {
  static const routeName = '/home-screen';
  const AppDrower({super.key});

  @override
  State<AppDrower> createState() => _AppDrowerState();
}

class _AppDrowerState extends State<AppDrower> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          DrawerHeader(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                "https://image.similarpng.com/very-thumbnail/2020/05/Online-shopping-3d-rendering-illustration-transparent-background-PNG.png",
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Home()));
            },
            leading: const Icon(
              // Icons.home_outlined,
              CupertinoIcons.home,
              color: Colors.orange,
              // color: Colors.orange,
            ),
            title: const Text(
              "Home",
              style: TextStyle(
                  fontFamily: 'Luzern', fontSize: 20, color: Colors.orange),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Home()));
            },
            leading: const Icon(
              CupertinoIcons.square_favorites_fill,
              color: Colors.orange,
            ),
            title: const Text(
              "Favorites",
              style: TextStyle(
                  fontFamily: 'Luzern', fontSize: 20, color: Colors.orange),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Home()));
            },
            leading: const Icon(
              CupertinoIcons.shopping_cart,
              color: Colors.orange,
            ),
            title: const Text(
              "Cart",
              style: TextStyle(
                  fontFamily: 'Luzern', fontSize: 20, color: Colors.orange),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Home()));
            },
            leading: const Icon(
              CupertinoIcons.shopping_cart,
              color: Colors.orange,
            ),
            title: const Text(
              "Orders",
              style: TextStyle(
                  fontFamily: 'Luzern', fontSize: 20, color: Colors.orange),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Home()));
            },
            leading: const Icon(
              CupertinoIcons.person_crop_rectangle_fill,
              color: Colors.orange,
            ),
            title: const Text(
              "Ask for Help",
              style: TextStyle(
                  fontFamily: 'Luzern', fontSize: 20, color: Colors.orange),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Home()));
            },
            leading: const Icon(
              CupertinoIcons.person_crop_circle_badge_plus,
              color: Colors.orange,
            ),
            title: const Text(
              "Update Profile",
              style: TextStyle(
                  fontFamily: 'Luzern', fontSize: 20, color: Colors.orange),
            ),
          ),
          const Spacer(),
          ListTile(
            onTap: () async {
              await AuthService().signOut();
            },
            leading: const Icon(
              CupertinoIcons.person_badge_minus,
              color: Colors.orange,
            ),
            title: const Text(
              "Logout",
              style: TextStyle(
                  fontFamily: 'Luzern', fontSize: 20, color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}
