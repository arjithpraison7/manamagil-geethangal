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
  final String assetPath;
  final String appBarTitle;
  const SongsSwiperPage({
    super.key,
    this.initialIndex = 0,
    this.assetPath = 'assets/songs_cleaned.json',
    this.appBarTitle = 'Songs',
  });

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
    final String csvString = await rootBundle.loadString(_getIndexPath());
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
  String _getIndexPath() {
    if (widget.assetPath.contains('sunday_school')) {
      return 'assets/sunday_school_index.csv';
    } else if (widget.assetPath.contains('aruthal')) {
      return 'assets/aruthal_geethangal_index.csv';
    } else {
      return 'assets/manamakizh_index.csv';
    }
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
    final String jsonString = await rootBundle.loadString(widget.assetPath);
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

  String _getFormattedTitle() {
    if (_songs.isEmpty || _currentIndex >= _songs.length) return widget.appBarTitle;
    
    final song = _songs[_currentIndex];
    final title = song['title']?.toString() ?? '';
    
    // Extract song number from title (e.g., "பாடல் 1" or "பாடல் 1 (பாமாலை 810)")
    final match = RegExp(r'பாடல்\s+(\d+)').firstMatch(title);
    if (match != null) {
      final songNumber = match.group(1);
      
      // Try to find the song name from index
      if (_index.isNotEmpty) {
        final indexEntry = _index.firstWhere(
          (entry) => entry[1] == songNumber,
          orElse: () => ['', ''],
        );
        if (indexEntry[0].isNotEmpty) {
          return 'பாடல் $songNumber : ${indexEntry[0]}';
        }
      }
      
      // Fallback to just song number if index not found
      return 'பாடல் $songNumber';
    }
    
    return title;
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
        currentSongsAssetPath: widget.assetPath,
        currentIndexAssetPath: _getIndexPath(),
        currentAppBarTitle: widget.appBarTitle,
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
        title: Text(
          _loading ? widget.appBarTitle : _getFormattedTitle(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
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