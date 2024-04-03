import 'package:flutter/material.dart';

void main() {
  runApp(MusicPlayerApp());
}

class MusicPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MusicPlayerScreen(),
    );
  }
}

class MusicPlayerScreen extends StatefulWidget {
  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  bool isPlaying = false;
  int currentTrackIndex = 0;

List<Map<String, String>> songs = [
  {
    'title': 'Jorthaale',
    'artist': 'Asal kolaar ',
    'album': 'Album 1',
    'albumArtUrl': 'assets/album_art/album1.jpg', // Path to local image file
    'filePath': 'assets/songs/jor.mp3',
  },
  {
    'title': 'Song 2',
    'artist': 'Artist 2',
    'album': 'Album 2',
    'albumArtUrl': 'assets/album_art/album2.jpg', // Path to local image file
    'filePath': 'assets/songs/song2.mp3',
  },
  // Add more songs as needed
];



  void playPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void nextTrack() {
    setState(() {
      currentTrackIndex = (currentTrackIndex + 1) % songs.length;
      // You might want to add logic here to stop the current track if it's playing
      isPlaying = false;
    });
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
          children: [
            Image.network(
              songs[currentTrackIndex]['albumArtUrl']!,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              songs[currentTrackIndex]['title']!,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              songs[currentTrackIndex]['artist']!,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              songs[currentTrackIndex]['album']!,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  iconSize: 36,
                  onPressed: () {
                    // Implement logic to play previous track if needed
                  },
                ),
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  iconSize: 48,
                  onPressed: playPause,
                ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  iconSize: 36,
                  onPressed: nextTrack,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



