import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _firstName;
  String? _lastName;
  String? _email;
  String? _role;
  String? _registrationDate;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // get user from Firebase Authentication
      final User? user = _auth.currentUser;
      if (user != null) {
        final String uid = user.uid;

        // get e-mail
        setState(() {
          _email = user.email;
        });

        // get user info from firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(uid).get();

        setState(() {
          _firstName = userDoc['firstName'];
          _lastName = userDoc['lastName'];
          _role = userDoc['role'];
          _registrationDate = DateFormat('yyyy-MM-dd HH:mm')
              .format(DateTime.parse(userDoc['registrationDate']));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load user data: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: _firstName == null || _lastName == null || _email == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      child: ClipOval(
                        child: SvgPicture.asset(
                          'assets/logo.svg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // user info cards
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text("Name"),
                      subtitle: Text("$_firstName $_lastName"),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text("Email"),
                      subtitle: Text(_email!),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text("Registration Date"),
                      subtitle: Text(_registrationDate!),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.assignment_ind),
                      title: const Text("Role"),
                      subtitle: Text(_role!),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
