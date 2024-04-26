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
        title: Text('Home'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Hi User',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // Navigate to home screen
            },
            child: Icon(Icons.home),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              // Navigate to profile screen
            },
            child: Icon(Icons.person),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, Widget page) {
    return Card(
      elevation: 5.0,
      child: InkWell(
        onTap: () {
          // Navigate to respective functionality screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
