import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String description;
  final String animationPath;

  Task({required this.description, required this.animationPath});
}

final List<Task> tasks = [
  Task(
      description: 'Check in with an elderly neighbor',
      animationPath: 'assets/elderly.json'),
  Task(
      description: 'Donate any unused clothes to your local charity',
      animationPath: 'assets/volunteer.json'),
  Task(
      description: 'Show love to a stray animal',
      animationPath: 'assets/love.json'),
  Task(
      description: 'Leave a positive review for a local business!',
      animationPath: 'assets/ratings.json'),
  Task(description: 'Plant a sapling ', animationPath: 'assets/sapling.json'),
  Task(description: 'Go on a short walk ', animationPath: 'assets/sun.json'),
  Task(
      description:
          'Collect any litter you see while walking in your neighborhood',
      animationPath: 'assets/trash.json'),
  Task(
      description: 'Sign an online petition ',
      animationPath: 'assets/volunteer.json'),
];

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('counter') ?? 0;
    });
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', _counter);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('imagePath', pickedFile.path);

      _uploadFeed();

      setState(() {
        _counter++;
        if (_counter >= tasks.length) {
          _counter = 0;
        }
      });

      await _saveState();
    }
  }

  // Function to handle image upload and social feed posting
  Future<void> _uploadFeed() async {
    if (_imageFile == null) {
      print('No image selected.');
      return;
    }

    try {
      // Create a reference to Firebase Storage root
      Reference referenceRoot = FirebaseStorage.instance.ref();

      // Create a reference to the directory "posts"
      Reference dirImages = referenceRoot.child('posts');

      // Create a reference to the file to upload (use a unique name)
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference imgToUpload = dirImages.child(uniqueFileName);

      // Upload the image file to Firebase Storage
      UploadTask uploadTask = imgToUpload.putFile(File(_imageFile!.path));

      // Wait for the upload to complete
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL after uploading
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      print('Image uploaded successfully! Image URL: $imageUrl');

      // Save the image URL to Firestore
      await FirebaseFirestore.instance.collection('images').add({
        'url': imageUrl,
        'uploaded_at': Timestamp.now(),
      });

      print('Image URL saved to Firestore.');
    } catch (error) {
      print('An error occurred during image upload: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = tasks[_counter];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Space between top and bottom
        crossAxisAlignment: CrossAxisAlignment.center, // Center the card
        children: [
          // Cute logo image placeholder
          Image.asset('assets/logo.png',
              width: 300, height: 300), // Adjust size as needed
          //SizedBox(height: 8), // Space between logo and card

          // Card with full width but not full length
          Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 20.0), // Padding on sides
            child: Container(
              padding: const EdgeInsets.all(16.0), // Padding inside the card
              constraints: BoxConstraints(
                  maxWidth:
                      MediaQuery.of(context).size.width * 0.9), // Card width
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    task.animationPath,
                    width: 230, // Twice the original size
                    height: 230,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    task.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 32), // Adjust font size as needed
                  ),
                ],
              ),
            ),
          ),

          // Image Picker Button
          SizedBox(
              width: 350,
              height: 100,
              child: ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Select Image',
                    style: TextStyle(
                        fontSize: 32,
                        fontFamily: "assets/ashcan-bb.regular.ttf",
                        color: Color.fromARGB(255, 247, 186, 65))),
              ))
        ],
      ),
    );
  }
}
