import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/login_page.dart';
import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

final _firebase = FirebaseAuth.instance;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();

  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  // bool _isVerificationEmailSent = false;
  File? _selectedImage;
  var _isAuthenticated = false;
  // final bool _isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
  /*
  void _verifyEmail() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      setState(() {
        _isVerificationEmailSent = true;
      });
    }
  }
  */
  void _register() async {
    final isValid = _registerFormKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    if (_selectedImage == null) {
      return;
    }

    _registerFormKey.currentState!.save();

    try {
      setState(() {
        _isAuthenticated = true;
      });

      var userCredentials = await _firebase.createUserWithEmailAndPassword(
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

      debugPrint(userCredentials.toString());
      //_verifyEmail();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful.'),
        ),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      /*
      if (_isVerificationEmailSent == true && _isVerified == true) {}
      */
    } on FirebaseAuthException catch (error) {
      debugPrint(error.toString());
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
      setState(() {
        _isAuthenticated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 400,
                height: 400,
                child: Image.asset('assets/images/logo/logo.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _registerFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /*
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Name'),
                            keyboardType: TextInputType.name,
                            autocorrect: false,
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Surname'),
                            keyboardType: TextInputType.name,
                            autocorrect: false,
                          ),
                          */
                          UserImagePicker(
                            onPickImage: (pickedImage) {
                              _selectedImage = pickedImage;
                            },
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Username'),
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
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Email'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long.';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (_isAuthenticated)
                            const CircularProgressIndicator(),
                          if (!_isAuthenticated)
                            ElevatedButton(
                              onPressed: _register,
                              child: const Text('Register'),
                            ),
                          if (!_isAuthenticated)
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              },
                              child:
                                  const Text('Already have an account? Login.'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
