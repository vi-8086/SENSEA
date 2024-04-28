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
      home: TodoPage(),
    );
  }
}

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _connectToDatabase();
  }

  Future<void> _connectToDatabase() async {
    try {
      await connection.open();
      _loadTasks();
    } catch (e) {
      print("Error connecting to database: $e");
    }
  }

  Future<void> _loadTasks() async {
    try {
      final result = await connection.query("SELECT * FROM todos");
      setState(() {
        _tasks = result.map((row) => row.toColumnMap()).toList();
      });
    } catch (e) {
      print("Error loading tasks: $e");
    }
  }

  Future<void> _addTask(String taskName) async {
    try {
      await connection.query("INSERT INTO todos (task) VALUES ('$taskName')");
      _loadTasks();
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  Future<void> _removeTask(int id) async {
    try {
      await connection.query("DELETE FROM todos WHERE id = $id");
      _loadTasks();
    } catch (e) {
      print("Error removing task: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo'),
        backgroundColor: Colors.brown[200], // Setting app bar color to pastel beige
      ),
      backgroundColor: Colors.brown[100], // Changing background color to pastel beige
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter a task...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _addTask(_controller.text),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return _buildTaskCard(task['id'], task['task']);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(int id, String taskName) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: Colors.brown[300], // Setting card color to pastel brown
      child: ListTile(
        leading: Checkbox(
          value: false,
          onChanged: (_) => _removeTask(id),
        ),
        title: Text(taskName),
      ),
    );
  }
}
