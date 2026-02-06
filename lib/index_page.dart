import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'songs_swiper.dart';
import 'app_drawer.dart';
import 'bible_verse_card.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List<List<String>> _index = [];
  List<dynamic> _songs = [];
  Set<int> _favourites = {};
  bool _loading = true;
  bool _sortByName = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadIndex();
    _loadSongs();
    _loadFavourites();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Future<void> _loadIndex() async {
  //   final String csvString = await rootBundle.loadString('assets/manamakizh_index.csv');
  //   final lines = csvString.split('\n');
  //   final index = <List<String>>[];
  //   for (final line in lines) {
  //     final parts = line.split(',');
  //     if (parts.length >= 2) {
  //       index.add([parts[0].trim(), parts[1].trim()]);
  //     }
  //   }
  //   setState(() {
  //     _index = index;
  //     _loading = false;
  //   });
  // }

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
      _loading = false;
    });
  }

  Future<void> _loadSongs() async {
    final String jsonString = await rootBundle.loadString('assets/manamakizh_songs_cleaned.json');
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
  void _openSong(BuildContext context, String songNumberStr) async {
    final String jsonString = await rootBundle.loadString('assets/manamakizh_songs_cleaned.json');
    final List songs = json.decode(jsonString);
    // Find the song in the JSON by number (title: 'பாடல் <number>')
    final songTitle = 'பாடல் $songNumberStr';
    final idx = songs.indexWhere((s) => (s['title'] ?? '').toString().trim() == songTitle);
    if (idx != -1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SongsSwiperPage(
            initialIndex: idx,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final sortedIndex = List<List<String>>.from(_index);
    if (_sortByName) {
      sortedIndex.sort((a, b) => a[0].compareTo(b[0]));
    } else {
      sortedIndex.sort((a, b) => int.tryParse(a[1])?.compareTo(int.tryParse(b[1]) ?? 0) ?? 0);
    }
    // Filter by search query
    final filteredIndex = _searchQuery.isEmpty
        ? sortedIndex
        : sortedIndex.where((item) => item[0].toLowerCase().contains(_searchQuery.toLowerCase()) || item[1].contains(_searchQuery)).toList();
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
          'Song Index',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(_sortByName ? Icons.sort_by_alpha : Icons.format_list_numbered),
            tooltip: _sortByName ? 'Sort by Number' : 'Sort by Name',
            color: Colors.white,
            onPressed: () {
              setState(() {
                _sortByName = !_sortByName;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const BibleVerseCard(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search songs',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: filteredIndex.length,
                    itemBuilder: (context, i) {
                      final name = filteredIndex[i][0];
                      final number = filteredIndex[i][1];
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
                            leading: CircleAvatar(
                              backgroundColor: Colors.deepPurple.shade100,
                              child: Text(
                                number,
                                style: TextStyle(
                                  color: Colors.deepPurple.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text('Song $number'),
                            trailing: Icon(Icons.chevron_right, color: Colors.deepPurple.shade300),
                            onTap: () => _openSong(context, number),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_sortByName && _searchQuery.isEmpty)
                  _buildAlphabetScrollBar(filteredIndex),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlphabetScrollBar(List<List<String>> sortedIndex) {
    // Get unique starting letters with their indices
    final letterMap = <String, int>{};
    for (int i = 0; i < sortedIndex.length; i++) {
      final firstChar = sortedIndex[i][0].isNotEmpty ? sortedIndex[i][0][0] : '';
      if (firstChar.isNotEmpty && !letterMap.containsKey(firstChar)) {
        letterMap[firstChar] = i;
      }
    }
    final letters = letterMap.keys.toList();

    return Container(
      width: 24,
      margin: const EdgeInsets.only(right: 4),
      child: Theme(
        data: ThemeData(
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: MaterialStateProperty.all(Colors.transparent),
            trackColor: MaterialStateProperty.all(Colors.transparent),
          ),
        ),
        child: ListView.builder(
          itemCount: letters.length,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final letter = letters[index];
            return GestureDetector(
              onTap: () {
                final targetIndex = letterMap[letter]!;
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    targetIndex * 76.0, // Card height + margins
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Container(
                height: MediaQuery.of(context).size.height / letters.length,
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    letter,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade700,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
