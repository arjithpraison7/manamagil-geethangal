import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'app_drawer.dart';

class FavouritesPage extends StatefulWidget {
  final List<Map<String, dynamic>> favourites;
  final void Function(int) onSongTap;

  const FavouritesPage({Key? key, required this.favourites, required this.onSongTap}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  List<dynamic> _songs = [];
  Set<int> _favourites = {};

  @override
  void initState() {
    super.initState();
    _loadSongs();
    _loadFavourites();
  }

  Future<void> _loadSongs() async {
    final String jsonString = await rootBundle.loadString('assets/songs_cleaned.json');
    setState(() {
      _songs = json.decode(jsonString);
    });
  }

  Future<void> _loadFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favourites = prefs.getStringList('favourites')?.map(int.parse).toSet() ?? {};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        context: context,
        favourites: _favourites,
        songs: _songs,
      ),
      appBar: AppBar(title: const Text('Favourites')),
      body: widget.favourites.isEmpty
          ? const Center(child: Text('No favourites yet.'))
          : ListView.builder(
              itemCount: widget.favourites.length,
              itemBuilder: (context, i) {
                final fav = widget.favourites[i];
                return ListTile(
                  title: Text(fav['title'] ?? ''),
                  subtitle: Text('Song ${fav['number'] ?? ''}'),
                  onTap: () => widget.onSongTap(fav['index'] ?? 0),
                );
              },
            ),
    );
  }
}
