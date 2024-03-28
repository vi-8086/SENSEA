import 'package:flutter/material.dart';

class JournalPage extends StatefulWidget {
  @override
  _JournalPageState createState() => _JournalPageState();
}

class JournalEntry {
  String text;
  DateTime dateTime;

  JournalEntry(this.text, this.dateTime);
}

class _JournalPageState extends State<JournalPage> {
  List<JournalEntry> journalEntries = [];
  TextEditingController journalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SENSEA - Journal'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: journalController,
              decoration: InputDecoration(
                labelText: 'Enter your journal entry',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  String entryText = journalController.text;
                  DateTime entryDateTime = DateTime.now();
                  journalEntries.add(JournalEntry(entryText, entryDateTime));
                  journalController.clear();
                });
              },
              child: Text('Save Entry'),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: journalEntries.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(journalEntries[index].text),
                    subtitle: Text(
                      '${journalEntries[index].dateTime}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
