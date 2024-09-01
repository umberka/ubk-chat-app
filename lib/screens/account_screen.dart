import 'package:chat_app/screens/login_page.dart';
import 'package:chat_app/utilities/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? _user;
  String _username = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _username = _user?.displayName ?? '';
    _email = _user?.email ?? '';
  }

  Future<void> _deleteUserAndAssociatedData() async {
    try {
      if (_user == null) return;

      String userId = _user!.uid;

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      String? imageUrl = userDoc['image_url'];

      if (imageUrl != null && imageUrl.isNotEmpty) {
        await _deleteImageFromStorage(imageUrl);
      }

      QuerySnapshot chatSnapshot = await _firestore
          .collection('chat')
          .where('userId', isEqualTo: userId)
          .get();

      for (QueryDocumentSnapshot chatDoc in chatSnapshot.docs) {
        await chatDoc.reference.delete();

        QuerySnapshot messageSnapshot =
            await chatDoc.reference.collection('messages').get();
        for (QueryDocumentSnapshot messageDoc in messageSnapshot.docs) {
          await messageDoc.reference.delete();
        }
      }

      await _firestore.collection('users').doc(userId).delete();

      await _user!.delete();

      debugPrint("User and associated data deleted successfully.");

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Account deleted'),
      ));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } catch (e) {
      debugPrint("Error deleting user and associated data: $e");

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to delete account'),
      ));
    }
  }

  Future<void> _deleteImageFromStorage(String imageUrl) async {
    try {
      Reference storageReference = _storage.refFromURL(imageUrl);

      await storageReference.delete();
      debugPrint('Image deleted successfully');
    } catch (e) {
      debugPrint('Error occurred while deleting the image: $e');
    }
  }

  void _confirmDeleteAccount() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
              'Are you sure you want to delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: red,
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteUserAndAssociatedData();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _editAccount() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _firestore.collection('users').doc(_user!.uid).update({
          'username': _username,
          'email': _email,
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Account details updated'),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to update account details'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _username,
                decoration: const InputDecoration(labelText: 'Username'),
                onSaved: (value) {
                  _username = value!;
                },
              ),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (value) {
                  _email = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _editAccount,
                child: const Text('Edit Account'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _confirmDeleteAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: red,
                ),
                child: const Text('Delete Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
