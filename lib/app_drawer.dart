import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'index_page.dart';
import 'favourites_page.dart';
import 'songs_swiper.dart';
import 'theme_page.dart';
import 'about_page.dart';

class AppDrawer extends StatelessWidget {
  final BuildContext context;
  final Set<int> favourites;
  final List<dynamic> songs;
  final Function(int)? onSongSelected;

  const AppDrawer({
    Key? key,
    required this.context,
    required this.favourites,
    required this.songs,
    this.onSongSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Center(
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Index'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const IndexPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.music_note),
            title: Text('Go to Song'),
            onTap: () async {
              Navigator.pop(context);
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
                final idx = songs.indexWhere((s) => (s['title'] ?? '').toString().trim() == songTitle);
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
            leading: Icon(Icons.favorite),
            title: Text('Favourites'),
            onTap: () {
              Navigator.pop(context);
              final favs = favourites.map((i) => {
                'title': songs[i]['title'],
                'number': (i + 1).toString(),
                'index': i,
              }).toList();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => FavouritesPage(
                    favourites: favs,
                    onSongTap: (idx) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SongsSwiperPage(initialIndex: idx),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Search'),
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
            leading: Icon(Icons.color_lens),
            title: Text('Theme'),
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
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Exit'),
            onTap: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
    );
  }
}
