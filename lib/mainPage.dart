import 'package:flutter/material.dart';
import 'task_page.dart';
import 'social_feed_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Index to keep track of the selected tab
  int _selectedIndex = 0;

  // Function to handle tab changes
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display either TaskPage or SocialFeedPage based on _selectedIndex
      body: _selectedIndex == 0 ? TaskPage() : SocialFeedPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Feed',
          ),
        ],
        currentIndex: _selectedIndex, // Highlight the selected tab
        onTap: _onItemTapped, // Handle tab changes
      ),
    );
  }
}
