import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'songs_swiper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SongbookSelectionPage(),
    );
  }
}

class SongbookSelectionPage extends StatelessWidget {
  const SongbookSelectionPage({super.key});

  void _openSongbook(BuildContext context, String assetPath, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SongsSwiperPage(
          initialIndex: 0,
          assetPath: assetPath,
          appBarTitle: title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Songbook'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.book, color: Colors.deepPurple),
                label: const Text('Manamagil Geethangal'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () => _openSongbook(
                  context,
                  'assets/songs_cleaned.json',
                  'Manamagil Geethangal',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.school, color: Colors.teal),
                label: const Text('Vidumurai Vethagama Padalgal'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () => _openSongbook(
                  context,
                  'sunday_school_songs_cleaned.json',
                  'Vidumurai Vethagama Padalgal',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.favorite, color: Colors.redAccent),
                label: const Text('Aruthal Geethangal'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () => _openSongbook(
                  context,
                  'aruthal_geethangal.json',
                  'Aruthal Geethangal',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
