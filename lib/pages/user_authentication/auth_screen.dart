// ignore_for_file: use_build_context_synchronously, unused_field, unused_local_variable

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:personal_finance/widgets/user_image_picker.dart';

final _firebase = FirebaseAuth.instance;
final _googleSignIn = GoogleSignIn();

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();

  var _isSignin = true;
  var _enteredUsername = '';
  var _enteredEmail = '';
  var _enteredPassword = '';
  File? _selectedImage;

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid || !_isSignin && _selectedImage == null) {
      return;
    }

    _form.currentState!.save();

    try {
      if (_isSignin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'image_url': imageUrl,
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        //...
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
    }
  }

  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        await _firebase.signInWithCredential(authCredential);
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_firebase.currentUser!.uid)
        .set({
      'username': '${_firebase.currentUser!.displayName}',
      'email': '${_firebase.currentUser!.email}',
      'image_url': _firebase.currentUser!.photoURL!,
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isSignin) {
      // Sign In Screen

      return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/signin_banner.png',
                    fit: BoxFit.fitWidth,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'BUDGETLY',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              labelText: 'Email Address',
                              labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(
                                  width: 2,
                                  style: BorderStyle.solid,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(
                                  width: 2,
                                  style: BorderStyle.solid,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 35,
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                        textAlign: TextAlign.right,
                      ),
                      onPressed: () => {},
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(90)),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Theme.of(context).colorScheme.primary),
                      ),
                      onPressed: _submit,
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Text(
                        ' or ',
                        style: TextStyle(fontSize: 14),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        )),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                      ),
                      onPressed: signInWithGoogle,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google_icon.png',
                            width: 20,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Sign in with Google Account',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have account ?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isSignin = false;
                          });
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      // Sign Up Screen

      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              setState(() {
                _isSignin = true;
              });
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          title: Text(
            'Sign Up',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Create New Account',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          UserImagePicker(
                            onPickImage: (pickedImage) {
                              _selectedImage = pickedImage;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.account_box,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              labelText: 'Username',
                              labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(
                                  width: 2,
                                  style: BorderStyle.solid,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            enableSuggestions: false,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().length < 4) {
                                return 'Please enter at least 4 characters.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredUsername = value!;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              labelText: 'Email Address',
                              labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(
                                  width: 2,
                                  style: BorderStyle.solid,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(
                                  width: 2,
                                  style: BorderStyle.solid,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90)),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) =>
                                        Theme.of(context).colorScheme.primary),
                              ),
                              onPressed: _submit,
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Row(
                            children: [
                              Expanded(child: Divider()),
                              Text(
                                ' or ',
                                style: TextStyle(fontSize: 14),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                )),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.white),
                              ),
                              onPressed: signInWithGoogle,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/google_icon.png',
                                    width: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Sign up with Google Account',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
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
          ),
        ),
      );
    }
  }
}
