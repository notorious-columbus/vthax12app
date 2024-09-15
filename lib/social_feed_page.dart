import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SocialFeedPage extends StatelessWidget {
  const SocialFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Happening Now'))),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('images').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final docs = snapshot.data?.docs;

          if (docs == null || docs.isEmpty) {
            return const Center(child: Text('No images available.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final imageUrl = data['url'] as String;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color
                    border: Border.all(
                      color: Colors.white, // Border color
                      width: 2.0, // Border width
                    ),
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Center the column
                    children: [
                      // Image at the top
                      SizedBox(
                        width: double.infinity, // Take full width
                        child: Image.network(imageUrl, fit: BoxFit.cover),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
