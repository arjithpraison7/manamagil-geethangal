import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'app_drawer.dart';
import 'theme_page.dart';

void main() {
  runApp(const SongsApp());
}

class SongsApp extends StatelessWidget {
  const SongsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tamil Songs Swiper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SongsSwiperPage(),
    );
  }
}

class SongsSwiperPage extends StatefulWidget {
  final int initialIndex;
  const SongsSwiperPage({super.key, this.initialIndex = 0});

  @override
  State<SongsSwiperPage> createState() => _SongsSwiperPageState();
}

class _SongsSwiperPageState extends State<SongsSwiperPage> {
  Set<int> _favourites = {};
  List<dynamic> _songs = [];
  int _currentIndex = 0;
  bool _loading = true;
  late ThemeSettings _themeSettings;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _themeSettings = ThemeSettings();
    _loadSongs();
    _loadFavourites();
    _loadThemeSettings();
  }

  Future<void> _loadThemeSettings() async {
    final settings = await ThemeSettings.load();
    setState(() {
      _themeSettings = settings;
    });
  }

  Future<void> _loadFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favourites = prefs.getStringList('favourites')?.map(int.parse).toSet() ?? {};
    });
  }

  Future<void> _toggleFavourite(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favourites.contains(index)) {
        _favourites.remove(index);
      } else {
        _favourites.add(index);
      }
      prefs.setStringList('favourites', _favourites.map((e) => e.toString()).toList());
    });
  }

  Future<void> _loadSongs() async {
    final String jsonString = await rootBundle.loadString('assets/songs_cleaned.json');
    setState(() {
      _songs = json.decode(jsonString);
      _loading = false;
    });
  }

  void _swipeRight() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _songs.length;
    });
  }

  void _swipeLeft() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _songs.length) % _songs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final song = _songs[_currentIndex];
    return Scaffold(
      drawer: AppDrawer(
        context: context,
        favourites: _favourites,
        songs: _songs,
        onSongSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
      ),
      appBar: AppBar(
        title: Center(
          child: Text(
            song['title'] ?? '',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          color: _themeSettings.useGradient ? null : _themeSettings.backgroundColor,
          gradient: _themeSettings.useGradient
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _themeSettings.gradientStartColor,
                    _themeSettings.gradientEndColor,
                  ],
                )
              : null,
        ),
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
              _swipeRight();
            } else if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
              _swipeLeft();
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            _favourites.contains(_currentIndex)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          tooltip: _favourites.contains(_currentIndex)
                              ? 'Remove from Favourites'
                              : 'Add to Favourites',
                          onPressed: () => _toggleFavourite(_currentIndex),
                        ),
                      ],
                    ),
                    Text(
                      song['lyrics'] ?? '',
                      style: TextStyle(
                        fontSize: _themeSettings.fontSize,
                        color: _themeSettings.textColor,
                        height: _themeSettings.lineSpacing,
                      ),
                      textAlign: _themeSettings.textAlignment,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}