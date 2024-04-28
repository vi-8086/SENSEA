import 'package:flutter/material.dart';
import 'package:sensea/screens/todo.dart'; 
import 'package:sensea/screens/journal.dart'; 
import 'package:sensea/screens/habit tracker.dart'; 
import 'package:sensea/screens/counsel.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.brown[200], // Setting app bar color to beige
      ),
      backgroundColor: Colors.brown[100], // Changing background color to beige
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Hi User',
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold,
                color: Colors.brown[800], // Making "Hi User" text brown
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 20.0,
              children: [
                _buildCard(context, 'TODO',
                    TodoPage()), // Navigate to TodoPage when tapped
                _buildCard(context, 'JOURNAL',
                    JournalPage()), // Navigate to JournalPage when tapped
                _buildCard(context, 'HABIT TRACKER',
                    HabitTrackerPage()), // Navigate to HabitTrackerPage when tapped
                _buildCard(context, 'ONLINE COUNSELLING',
                    CounselingPage()), // Navigate to CounselingPage when tapped
                // Add more functionality cards as needed
              ],
            ),
          ),
        ],
      ),
      
    );
  }

  Widget _buildCard(BuildContext context, String title, Widget page) {
    return Card(
      elevation: 5.0,
      color: Colors.brown[300], // Setting card color to beige
      child: InkWell(
        onTap: () {
          // Navigate to respective functionality screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                fontFamily: 'Quirky', // Setting font family to a quirky sans serif font
                color: Colors.brown[50], // Setting font color to complementary beige
              ),
            ),
          ),
        ),
      ),
    );
  }
}
