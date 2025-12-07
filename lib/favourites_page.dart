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
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Favourites',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: widget.favourites.isEmpty
          ? const Center(child: Text('No favourites yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: widget.favourites.length,
              itemBuilder: (context, i) {
                final fav = widget.favourites[i];
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 300 + (i * 50).clamp(0, 500)),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(20 * (1 - value), 0),
                        child: child,
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.favorite,
                        color: Colors.red.shade400,
                      ),
                      title: Text(
                        fav['title'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text('Song ${fav['number'] ?? ''}'),
                      trailing: Icon(Icons.chevron_right, color: Colors.deepPurple.shade300),
                      onTap: () => widget.onSongTap(fav['index'] ?? 0),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
