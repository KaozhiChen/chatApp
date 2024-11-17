import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _email;
  String? _role;
  String? _firstName;
  String? _lastName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final String uid = user.uid;

      // get email
      setState(() {
        _email = user.email;
      });

      // get other info from firebase
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      setState(() {
        _firstName = userDoc['firstName'];
        _lastName = userDoc['lastName'];
        _role = userDoc['role'];
      });
    }
  }

  Future<void> _updateField(
      String field, String newValue, String successMessage) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final String uid = user.uid;

      // update user info
      if (field == 'email') {
        await user.verifyBeforeUpdateEmail(newValue);
      } else {
        await _firestore.collection('users').doc(uid).update({field: newValue});
      }

      setState(() {
        if (field == 'email') _email = newValue;
        if (field == 'firstName') _firstName = newValue;
        if (field == 'lastName') _lastName = newValue;
        if (field == 'role') _role = newValue;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update $field: $e")),
      );
    }
  }

  void _showEditDialog(String title, String field, String currentValue) {
    final TextEditingController _controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit $title"),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: "Enter new $title"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final String newValue = _controller.text.trim();
                if (newValue.isNotEmpty) {
                  _updateField(
                    field,
                    newValue,
                    "$title updated successfully!",
                  );
                }
                Navigator.pop(context);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: _email == null ||
              _firstName == null ||
              _lastName == null ||
              _role == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoCard(
                    title: "Email",
                    value: _email!,
                    field: "email",
                  ),
                  _buildInfoCard(
                    title: "First Name",
                    value: _firstName!,
                    field: "firstName",
                  ),
                  _buildInfoCard(
                    title: "Last Name",
                    value: _lastName!,
                    field: "lastName",
                  ),
                  _buildInfoCard(
                    title: "Role",
                    value: _role!,
                    field: "role",
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      await _auth.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text("Logout"),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard(
      {required String title, required String value, required String field}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.info_outline),
        title: Text(title),
        subtitle: Text(value),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _showEditDialog(title, field, value),
        ),
      ),
    );
  }
}
