import 'package:flutter/material.dart';
import 'package:sensea/database/database.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal',
      home: JournalPage(),
      theme: ThemeData(
        primaryColor: Colors.brown[200], colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.brown[800]), // Setting accent color to brown
      ),
    );
  }
}

class JournalPage extends StatefulWidget {
  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State
{
  final TextEditingController _controller = TextEditingController();
  String _dayQuality = '';
  List<Map<String, String>> _entries = [];

  @override
  void initState() {
    super.initState();
    initdbConnection();
  }

  void initdbConnection() async {
    await connection.open();
    print("Database Connected!");
  }

  void dispose() {
    connection.close();
    super.dispose();
  }

  void _addEntry() async {
    final String entry = _controller.text;
    final DateTime now = DateTime.now();
    final String dateTime = '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}';

    try {
      await connection.query("INSERT INTO journal (entry) VALUES ('$entry')");
      setState(() {
        if (_dayQuality.isNotEmpty) {
          _entries.add({
            'entry': entry,
            'quality': _dayQuality,
            'dateTime': dateTime,
          });
          _controller.clear();
          _dayQuality = '';
        }
      });
    } catch (e) {
      print("Error adding entry: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hey user, how was your day?',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _dayQuality = 'good';
                        });
                      },
                      child: Text('Good'),
                    ),
                    SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _dayQuality = 'bad';
                        });
                      },
                      child: Text('Bad'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final Map<String, String> entry = _entries[index];
                return _buildEntryCard(entry);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Write your journal entry...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addEntry,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryCard(Map<String, String> entry) {
    if (entry['quality'] == 'good') {
      return Card(
        margin: EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date & Time: ${entry['dateTime']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(entry['entry']!),
            ],
          ),
        ),
      );
    } else {
      return Container(); // Return an empty container if the day was bad
    }
  }
}
