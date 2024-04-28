import 'package:flutter/material.dart';
import 'package:sensea/database/database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      home: HabitTrackerPage(),
    );
  }
}

class HabitTrackerPage extends StatefulWidget {
  @override
  _HabitTrackerPageState createState() => _HabitTrackerPageState();
}

class _HabitTrackerPageState extends State<HabitTrackerPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _habits = [];

  @override
  void initState() {
    super.initState();
    _connectToDatabase();
  }

  Future<void> _connectToDatabase() async {
    try {
      await connection.open();
      _loadHabits();
    } catch (e) {
      print("Error connecting to database: $e");
    }
  }

  Future<void> _loadHabits() async {
    try {
      final result =
          await connection.query("SELECT * FROM habits ORDER BY id ASC");
      setState(() {
        _habits = result.map((row) => row.toColumnMap()).toList();
      });
    } catch (e) {
      print("Error loading habits: $e");
    }
  }

  Future<void> _addHabit(String habitName) async {
    try {
      await connection.query("INSERT INTO habits (name) VALUES ('$habitName')");
      _loadHabits();
    } catch (e) {
      print("Error adding habit: $e");
    }
  }

  Future<void> _completeHabit(int id) async {
    try {
      await connection.query(
          "UPDATE habits SET streak_maintained = streak_maintained + 1, entries = entries + 1 WHERE id = $id");
      _loadHabits();
    } catch (e) {
      print("Error completing habit: $e");
    }
  }

  Future<void> _incompleteHabit(int id) async {
    try {
      await connection
          .query("UPDATE habits SET entries = entries + 1 WHERE id = $id");
      _loadHabits();
    } catch (e) {
      print("Error marking habit as incomplete: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor:
            Colors.brown[200], // Setting app bar color to pastel beige
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Habits',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800]), // Changing text color to brown
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                final habit = _habits[index];
                final streakMaintained = habit['streak_maintained'];
                final entries = habit['entries'];
                final streakPercentage = (streakMaintained / entries) * 100;
                return _buildHabitCard(
                  habit['id'],
                  habit['name'],
                  streakMaintained,
                  entries,
                  streakPercentage,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Habit',
                    style: TextStyle(
                        color:
                            Colors.brown[800])), // Changing text color to brown
                content: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Enter habit...',
                    hintStyle: TextStyle(
                        color: Colors
                            .brown[800]), // Changing hint text color to brown
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel',
                        style: TextStyle(
                            color: Colors.brown[
                                50])), // Changing text color to complementary beige
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[
                          300], // Setting button color to complementary beige
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addHabit(_controller.text);
                      Navigator.pop(context);
                    },
                    child: Text('Add',
                        style: TextStyle(
                            color: Colors.brown[
                                50])), // Changing text color to complementary beige
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[
                          300], // Setting button color to complementary beige
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor:
            Colors.brown[300], // Setting button color to complementary beige
      ),
    );
  }

  Widget _buildHabitCard(int id, String habitName, int streakMaintained,
      int entries, streakPercentage) {
    double streakPercentage =
        entries != 0 ? (streakMaintained / entries) * 100 : 0;

    return Card(
      margin: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: Colors.brown[100], // Setting card color to pastel beige
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              habitName,
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800]), // Changing text color to brown
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Streak: $streakMaintained/$entries',
                    style: TextStyle(
                        color:
                            Colors.brown[800])), // Changing text color to brown
                Text(
                    'Streak Percentage: ${streakPercentage.toStringAsFixed(2)}%',
                    style: TextStyle(
                        color:
                            Colors.brown[800])), // Changing text color to brown
              ],
            ),
            SizedBox(height: 8.0),
            LinearProgressIndicator(
              value: streakPercentage / 100,
              backgroundColor: Colors.brown[
                  300], // Changing progress bar background color to light brown
              valueColor: AlwaysStoppedAnimation<Color>(Colors
                  .brown[800]!), // Changing progress bar value color to brown
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _completeHabit(id);
                  },
                  child: Text('✓ Complete',
                      style: TextStyle(
                          color: Colors.brown[
                              50])), // Changing text color to complementary beige
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[
                        300], // Setting button color to complementary beige
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _incompleteHabit(id);
                  },
                  child: Text('✗ Incomplete',
                      style: TextStyle(
                          color: Colors.brown[
                              50])), // Changing text color to complementary beige
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[
                        300], // Setting button color to complementary beige
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
