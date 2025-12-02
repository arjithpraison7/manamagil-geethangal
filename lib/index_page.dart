import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'songs_swiper.dart';
import 'app_drawer.dart';

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
  void _openSong(BuildContext context, String songNumberStr) async {
    final String jsonString = await rootBundle.loadString('assets/songs_cleaned.json');
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
        title: const Text('Song Index'),
        actions: [
          IconButton(
            icon: Icon(_sortByName ? Icons.sort_by_alpha : Icons.format_list_numbered),
            tooltip: _sortByName ? 'Sort by Number' : 'Sort by Name',
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
                      return ListTile(
                        title: Text(name),
                        subtitle: Text('Song $number'),
                        onTap: () => _openSong(context, number),
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
    // Get unique starting letters
    final letters = <String>[];
    for (final item in sortedIndex) {
      final firstChar = item[0].isNotEmpty ? item[0][0] : '';
      if (firstChar.isNotEmpty && !letters.contains(firstChar)) {
        letters.add(firstChar);
      }
    }

    return Container(
      width: 40,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border(left: BorderSide(color: Colors.grey[400]!, width: 1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: letters.map((letter) {
          return GestureDetector(
            onTap: () {
              // Find the first song starting with this letter
              final targetIndex = sortedIndex.indexWhere((item) => item[0].startsWith(letter));
              if (targetIndex != -1 && _scrollController.hasClients) {
                // Scroll to the position (approximate)
                _scrollController.animateTo(
                  targetIndex * 72.0, // Approximate ListTile height
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              child: Text(
                letter,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
