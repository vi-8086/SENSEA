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

class MusicPlayer extends StatelessWidget {
  static const platform = MethodChannel('audio_player');

  Future<void> _playPause() async {
    try {
      await platform.invokeMethod('playPause');
    } on PlatformException catch (e) {
      print("Failed to play/pause audio: '${e.message}'.");
    }
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
            IconButton(
              icon: Icon(Icons.play_arrow),
              iconSize: 48.0,
              onPressed: _playPause,
            ),
          ],
        ),
      ),
    );
  }
}
