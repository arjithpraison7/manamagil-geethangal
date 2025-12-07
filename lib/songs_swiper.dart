import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'app_drawer.dart';
import 'theme_page.dart';
import 'splash_screen.dart';
import 'notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize and schedule notifications
  await NotificationService.initialize();
  await NotificationService.requestPermissions();
  await NotificationService.scheduleDailyBibleVerse();
  
  runApp(const SongsApp());
}

class SongsApp extends StatelessWidget {
  const SongsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tamil Songs Swiper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const SplashScreen(),
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
  List<List<String>> _index = [];
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
    _loadIndex();
  }

  Future<void> _loadIndex() async {
    final String csvString = await rootBundle.loadString('assets/manamakizh_index.csv');
    final lines = csvString.split('\n');
    final index = <List<String>>[];
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      final lastComma = line.lastIndexOf(',');
      if (lastComma != -1) {
        final name = line.substring(0, lastComma).trim();
        final number = line.substring(lastComma + 1).trim();
        index.add([name, number]);
      }
    }
    setState(() {
      _index = index;
    });
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

  String _getSongHeaderText(dynamic song) {
    // Try to get the index name for this song
    final songNumber = song['song_number']?.toString() ?? (_currentIndex + 1).toString();
    final indexEntry = _index.firstWhere(
      (entry) => entry[1] == songNumber,
      orElse: () => []
    );
    if (indexEntry.isNotEmpty) {
      return indexEntry[0];
    }
    // fallback: use title
    return song['title'] ?? '';
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
        title: Hero(
          tag: 'appTitle',
          child: Material(
            color: Colors.transparent,
            child: Text(
              _getSongHeaderText(song),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              _favourites.contains(_currentIndex)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.white,
              size: 28,
            ),
            tooltip: _favourites.contains(_currentIndex)
                ? 'Remove from Favourites'
                : 'Add to Favourites',
            onPressed: () => _toggleFavourite(_currentIndex),
          ),
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
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
                    TweenAnimationBuilder<double>(
                      key: ValueKey(_currentIndex),
                      duration: const Duration(milliseconds: 500),
                      tween: Tween(begin: 0.0, end: 1.0),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.scale(
                            scale: 0.95 + (0.05 * value),
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          song['lyrics'] ?? '',
                          style: TextStyle(
                            fontSize: _themeSettings.fontSize,
                            color: _themeSettings.textColor,
                            height: _themeSettings.lineSpacing,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5,
                          ),
                          textAlign: _themeSettings.textAlignment,
                        ),
                      ),
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