import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//Class that handles all Authentication methods of the application using Firebase
class AuthService {
  // Create a new auth service instance
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Register a new user with email and password as a Future User and User can be null
  Future<User?> register(
      String email, String password, BuildContext context) async {
    //Try and catch the error block jhus in case the app gets bad input so as not to crash
    try {
      //Creating the user using firebase
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      //on getting any error show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      //else prints the error message onto the console
      print(e);
    }
    return null;
  }

  // Login a user using the provided username and password to Firebase
  Future<User?> login(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      print(e);
    }
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }
}
