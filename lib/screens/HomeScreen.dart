import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/AuthProviders.dart';
import 'ProfileScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sign Out'),
                  content: const Text('Are you sure you want to sign out?'),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: const Text('Sign Out'),
                      onPressed: () {
                        Navigator.pop(context);
                        authProvider.signOut();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user != null) ...[
              if (user.photoURL != null)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(user.photoURL!),
                ),

              const SizedBox(height: 16),

              Text(
                'Welcome, ${user.displayName ?? 'User'}!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                'Email: ${user.email ?? 'Anonymous'}',
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 8),

              if (user.isAnonymous)
                const Text(
                  '(Signed in anonymously)',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),

              if (!user.isAnonymous && !user.emailVerified) ...[
                const SizedBox(height: 16),

                const Text(
                  'Email not verified',
                  style: TextStyle(color: Colors.orange),
                ),

                TextButton(
                  onPressed: () async {
                    try {
                      await user.sendEmailVerification();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Verification email sent!'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Resend Verification Email'),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}