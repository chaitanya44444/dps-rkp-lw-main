import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lw/models/user.dart';
import 'package:lw/services/database_services.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  UserModel? userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final uid = auth.currentUser?.uid;

    if (uid == null || uid.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    try {
      final docSnapshot = await DatabaseService().getDocSnapshot(uid);

      if (mounted) {
        if (docSnapshot.exists && docSnapshot.data() != null) {
          UserModel? data = UserModel.fromJson(docSnapshot.data() as Map<String, dynamic>);
          setState(() {
            userData = data;
            _isLoading = false;
          });
        } else {
          setState(() {
            userData = null;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          userData = null;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Influencer App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? const Center(child: Text("User data not found or error loading."))
              : Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/profile_picture.png'),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              Text(
                                userData!.username,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () async {
                                  if (!mounted) return;

                                  TextEditingController usernameController = TextEditingController(text: userData!.username);
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Edit Username'),
                                        content: TextField(
                                          controller: usernameController,
                                          decoration: const InputDecoration(
                                            labelText: 'Username',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              String newUsername = usernameController.text.trim();
                                              if (newUsername.isNotEmpty) {
                                                if (!mounted) return;
                                                await DatabaseService().updateUserField(
                                                  auth.currentUser?.uid ?? "",
                                                  'username',
                                                  newUsername,
                                                );
                                                if (mounted) {
                                                  setState(() {
                                                    userData?.username = newUsername;
                                                  });
                                                }
                                              }
                                              if (mounted) {
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            child: const Text('Save'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('(Edit)', style: TextStyle(fontSize: 10)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            userData?.email ?? "Email not found",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 20),
                          ListTile(
                            leading: const Icon(Icons.interests),
                            title: const Text('Change Interests'),
                            onTap: () {
                              if (userData?.username != null && userData?.interests != null) {
                                Navigator.pushNamed(
                                  context,
                                  "/interests",
                                  arguments: [userData!.username, userData!.interests],
                                );
                              }
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text('Logout'),
                            onTap: () async {
                              try {
                                if (!mounted) return;
                                await auth.signOut();
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Error logging out: $e',
                                        style: const TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  );
                                }
                              }

                              if (mounted) {
                                Navigator.pushNamed(
                                  context,
                                  "/sign-up",
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
