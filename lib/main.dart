import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'splash_screen.dart';
import 'songbook_index_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'இயேசுவை போற்றும் பாடல்கள்',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
    );
  }
}

class SongbookSelectionPage extends StatelessWidget {
  const SongbookSelectionPage({super.key});

  void _openSongbook(BuildContext context, String songsAssetPath, String indexAssetPath, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SongbookIndexPage(
          songsAssetPath: songsAssetPath,
          indexAssetPath: indexAssetPath,
          appBarTitle: title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('பாடல் புத்தகங்கள்', style: TextStyle(fontSize: 20)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSquareButton(
                context,
                'மனமகிழ் கீதங்கள்',
                Icons.music_note,
                Colors.deepPurple,
                () => _openSongbook(
                  context,
                  'assets/manamakizh_songs_cleaned.json',
                  'assets/manamakizh_index.csv',
                  'மனமகிழ் கீதங்கள்',
                ),
              ),
              const SizedBox(height: 20),
              _buildSquareButton(
                context,
                'ஞாயிறு பள்ளி பாடல்கள்',
                Icons.school,
                Colors.teal,
                () => _openSongbook(
                  context,
                  'assets/sunday_school_songs_cleaned.json',
                  'assets/sunday_school_index.csv',
                  'ஞாயிறு பள்ளி பாடல்கள்',
                ),
              ),
              const SizedBox(height: 20),
              _buildSquareButton(
                context,
                'ஆறுதல் கீதங்கள்',
                Icons.favorite,
                Colors.red,
                () => _openSongbook(
                  context,
                  'assets/aruthal_geethangal.json',
                  'assets/aruthal_geethangal_index.csv',
                  'ஆறுதல் கீதங்கள்',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSquareButton(BuildContext context, String text, IconData icon, MaterialColor color, VoidCallback onPressed) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.shade300, color.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
