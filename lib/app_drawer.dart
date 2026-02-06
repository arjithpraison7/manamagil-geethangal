import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'index_page.dart';
import 'favourites_page.dart';
import 'songs_swiper.dart';
import 'theme_page.dart';
import 'about_page.dart';
import 'help_page.dart';
import 'main.dart';
import 'songbook_index_page.dart';

class AppDrawer extends StatelessWidget {
  final BuildContext context;
  final Set<int> favourites;
  final List<dynamic> songs;
  final Function(int)? onSongSelected;
  final String? currentSongsAssetPath;
  final String? currentIndexAssetPath;
  final String? currentAppBarTitle;

  const AppDrawer({
    Key? key,
    required this.context,
    required this.favourites,
    required this.songs,
    this.onSongSelected,
    this.currentSongsAssetPath,
    this.currentIndexAssetPath,
    this.currentAppBarTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade700, Colors.purple.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.church,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: Text(
                    currentAppBarTitle ?? 'மனமகிழ் கீதங்கள்',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Text(
                  'Tamil Songs',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.library_books),
            title: const Text(
              'Switch Category',
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const SongbookSelectionPage()),
                (route) => false,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text(
              'Index',
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.pop(context);
              if (currentSongsAssetPath != null && currentIndexAssetPath != null && currentAppBarTitle != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SongbookIndexPage(
                      songsAssetPath: currentSongsAssetPath!,
                      indexAssetPath: currentIndexAssetPath!,
                      appBarTitle: currentAppBarTitle!,
                    ),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const IndexPage()),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.music_note),
            title: const Text(
              'Go to Song',
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () async {
              final controller = TextEditingController();
              final result = await showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Go to Song'),
                  content: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Enter song number'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, controller.text),
                      child: const Text('Go'),
                    ),
                  ],
                ),
              );
              if (result != null && int.tryParse(result) != null) {
                final enteredNumber = result.trim();
                final songTitle = 'பாடல் $enteredNumber';
                // Try exact match first, then prefix match
                var idx = songs.indexWhere((s) => (s['title'] ?? '').toString().trim() == songTitle);
                if (idx == -1) {
                  idx = songs.indexWhere((s) => (s['title'] ?? '').toString().trim().startsWith('$songTitle '));
                }
                if (idx != -1) {
                  // Use root navigator context to avoid deactivated context
                  final navContext = Navigator.of(context, rootNavigator: true).context;
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacement(
                      navContext,
                      MaterialPageRoute(
                        builder: (_) => SongsSwiperPage(
                          initialIndex: idx,
                          assetPath: currentSongsAssetPath ?? 'assets/manamakizh_songs_cleaned.json',
                          appBarTitle: currentAppBarTitle ?? 'Songs',
                        ),
                      ),
                    );
                  });
                }
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text(
              'Favourites',
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () async {
              Navigator.pop(context);
              final prefs = await SharedPreferences.getInstance();
              final raw = prefs.getStringList('favourites_v2') ?? [];
              final favs = <Map<String, dynamic>>[];
              for (final item in raw) {
                try {
                  final decoded = json.decode(item);
                  if (decoded is Map<String, dynamic>) {
                    favs.add(decoded);
                  }
                } catch (_) {
                  // ignore malformed
                }
              }
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => FavouritesPage(
                    favourites: favs,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text(
              'Search',
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () async {
              Navigator.pop(context);
              final controller = TextEditingController();
              final result = await showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Search'),
                  content: TextField(
                    controller: controller,
                    decoration: const InputDecoration(hintText: 'Enter song title or number'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, controller.text),
                      child: const Text('Search'),
                    ),
                  ],
                ),
              );
              if (result != null && result.isNotEmpty) {
                final idx = songs.indexWhere((s) =>
                  (s['title'] ?? '').toString().toLowerCase().contains(result.toLowerCase()) ||
                  (s['lyrics'] ?? '').toString().toLowerCase().contains(result.toLowerCase()) ||
                  (result == ((songs.indexOf(s) + 1).toString()))
                );
                if (idx != -1 && onSongSelected != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SongsSwiperPage(initialIndex: idx),
                    ),
                  );
                }
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text(
              'Theme',
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () async {
              Navigator.pop(context);
              final settings = await ThemeSettings.load();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ThemePage(
                    initialSettings: settings,
                    onSettingsChanged: (newSettings) {
                      // Settings are automatically saved in ThemePage
                    },
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text(
              'About',
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text(
              'Help',
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              'Exit',
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
    );
  }
}
