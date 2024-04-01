import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MusicPlayer(),
    );
  }
}

class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  static const platform = MethodChannel('audio_player');
  String _mood = '';

  Future<void> _playMusic(String mood) async {
    try {
      await platform.invokeMethod('playMusic', {'mood': mood});
    } on PlatformException catch (e) {
      print("Failed to play music: '${e.message}'.");
    }
  }

  Future<void> _showMoodDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Your Mood'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _mood = 'Happy';
                    Navigator.pop(context);
                    _playMusic(_mood);
                  });
                },
                child: Text('Happy'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _mood = 'Sad';
                    Navigator.pop(context);
                    _playMusic(_mood);
                  });
                },
                child: Text('Sad'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _mood = 'Anxious';
                    Navigator.pop(context);
                    _playMusic(_mood);
                  });
                },
                child: Text('Anxious'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Sample Music Player',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _showMoodDialog,
              child: Text('Select Mood'),
            ),
          ],
        ),
      ),
    );
  }
}
