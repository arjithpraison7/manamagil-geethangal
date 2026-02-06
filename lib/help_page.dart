import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Help',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.8 + (0.2 * value),
                    child: child,
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.help_outline,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'How to Use This App',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Complete Guide to All Features',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.deepPurple,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  _buildFeatureItem(
                    icon: Icons.library_books,
                    title: 'Browse Song Categories',
                    description: 'Access three collections: மனமகிழ் கீதங்கள் (210 songs), ஞாயிறு பள்ளி பாடல்கள் (90 songs), and ஆறுதல் கீதங்கள் (comfort songs).',
                    imagePath: 'assets/help/Category.png',
                  ),
                  
                  _buildFeatureItem(
                    icon: Icons.swipe,
                    title: 'Swipe Through Songs',
                    description: 'Swipe left or right to navigate between songs. You can also use the arrow buttons at the bottom of the screen.',
                    imagePath: null,
                  ),
                  
                  _buildFeatureItem(
                    icon: Icons.list,
                    title: 'View Song Index',
                    description: 'Access the complete song list from the menu. Tap any song to jump directly to it. Sort songs by number or name.',
                    imagePath: 'assets/help/IndexPage.png',
                  ),
                  
                  _buildFeatureItem(
                    icon: Icons.search,
                    title: 'Search for Songs',
                    description: 'Use the search feature to find songs by title, lyrics, or song number. Search works across all content.',
                    imagePath: 'assets/help/SongSearch.png',
                  ),
                  
                  _buildFeatureItem(
                    icon: Icons.music_note,
                    title: 'Go to Specific Song',
                    description: 'Enter a song number to jump directly to that song. Quick access to your favorite songs!',
                    imagePath: 'assets/help/SongNumber.png',
                  ),
                  
                  _buildFeatureItem(
                    icon: Icons.favorite,
                    title: 'Mark Favorites',
                    description: 'Tap the heart icon to add songs to your favorites. Access all favorites from the menu for quick reference.',
                    imagePath: 'assets/help/Favourites.png',
                  ),
                  
                                    
                  _buildFeatureItem(
                    icon: Icons.color_lens,
                    title: 'Customize Theme',
                    description: 'Personalize your reading experience by adjusting font size, choosing background colors, and selecting text colors.',
                    imagePath: 'assets/help/Theme.png',
                  ),
                  
                  _buildFeatureItem(
                    icon: Icons.notifications,
                    title: 'Daily Bible Verse',
                    description: 'Receive a daily inspirational Bible verse notification with beautiful Tamil scriptures to start your day.',
                    imagePath: null,
                  ),
                  
                  _buildFeatureItem(
                    icon: Icons.menu_book,
                    title: 'Bible Verse Card',
                    description: 'View a featured Bible verse on the song page with a beautiful design. Swipe or tap to see different verses.',
                    imagePath: null,
                  ),
                  
                  _buildFeatureItem(
                    icon: Icons.switch_account,
                    title: 'Switch Categories',
                    description: 'Easily switch between song collections from the menu without losing your place.',
                    imagePath: null,
                  ),
                  
                  _buildFeatureItem(
                    icon: Icons.zoom_in,
                    title: 'Adjust Font Size',
                    description: 'Make text larger or smaller in the theme settings for comfortable reading. Great for all ages!',
                    imagePath: null,
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    String? imagePath,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.deepPurple,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            if (imagePath != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
