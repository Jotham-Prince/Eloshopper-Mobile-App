import 'package:best_eshopper_application/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Checkout extends StatefulWidget {
  List cartContents;
  int total;
  Checkout({super.key, required this.cartContents, required this.total});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  //Controllers that pick input from the specificed text fields
  TextEditingController userName = TextEditingController();
  TextEditingController phoneContact = TextEditingController();
  TextEditingController location = TextEditingController();

  //Boolean for the spinner showing the loading process
  //set to false because no button has been pressed to submit anything
  bool loading = false;

  //UI of the register page
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    String id = user!.uid;

    deleteFromCart() {
      FirebaseFirestore.instance.collection('Cart').doc(id).delete();
    }

    return Scaffold(
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
        title: const Text('Make Order with Cash!'),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        const Divider(
          height: 50,
        ),
        Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 5,
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text("Checkout",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Luzern',
            )),
        const Text("Order to be recieved with Cash payment",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Luzern',
            )),
        Container(
          margin: const EdgeInsets.only(left: 16.0, right: 21.0),
          height: MediaQuery.of(context).size.height / 1.67,
          width: MediaQuery.of(context).size.width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontFamily: 'Josefin'),
                  controller: userName,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      width: 3,
                      color: Colors.black45,
                    )),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.black45,
                      ),
                    ),
                    hintText: "Enter your real name",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff888b91),
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontFamily: 'Josefin'),
                  controller: phoneContact,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      width: 3,
                      color: Colors.black45,
                    )),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    hintText: "Enter your Phone Number",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 127, 130, 135),
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontFamily: 'Josefin'),
                  controller: location,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      width: 3,
                      color: Colors.black45,
                    )),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.black45,
                      ),
                    ),
                    hintText: "Enter your Location Address",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff888b91),
                      fontSize: 18,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      "Please provide correct information",
                      style: TextStyle(
                        fontFamily: 'Josefin',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    )
                  ],
                ),
                Center(
                  //where the loading circular indicator is placed
                  child: loading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () async {
                              final navigator = Navigator.of(context);
                              setState(() {
                                //changes to state of the loading indicator to true
                                //so that it is visible
                                loading = true;
                              });
                              //Validate and make sure the text fields are not empty
                              if (userName.text == "" ||
                                  location.text == "" ||
                                  phoneContact.text == "") {
                                //if empty, show snackbar error messages
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("All Fields are required!"),
                                  backgroundColor: Colors.red,
                                ));
                              } else {
                                //send order
                                DateTime currentTime = DateTime.now();
                                Map<String, dynamic> order = {
                                  'uid': id,
                                  'userName': userName.text,
                                  'location': location.text,
                                  'phoneNumber': phoneContact.text,
                                  'cartContents': widget.cartContents,
                                  'timeStamp': currentTime,
                                  'total': widget.total
                                };
                                FirebaseFirestore.instance
                                    .collection('Orders')
                                    .doc()
                                    .set(order);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Your order has been recieved successfuly")));
                                deleteFromCart();
                                navigator.push(MaterialPageRoute(
                                    builder: (
                                  _,
                                ) =>
                                        const Home()));
                              }
                              setState(() {
                                //after the user has been registered successfully
                                //set back the loading state to false and remove the
                                //circular loading process
                                loading = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28.0),
                              ),
                            ),
                            child: const Text(
                              "Order",
                              style: TextStyle(
                                fontFamily: 'Josefin',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ),
                ),
              ]),
        )
      ])),
    );
  }
}
