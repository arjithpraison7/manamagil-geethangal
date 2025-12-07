import 'package:flutter/material.dart';
import 'bible_verse_service.dart';

class BibleVerseCard extends StatefulWidget {
  const BibleVerseCard({Key? key}) : super(key: key);

  @override
  State<BibleVerseCard> createState() => _BibleVerseCardState();
}

class _BibleVerseCardState extends State<BibleVerseCard> {
  BibleVerse? _verse;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadVerse();
  }

  Future<void> _loadVerse() async {
    setState(() => _loading = true);
    try {
      final verse = await BibleVerseService.getDailyVerse();
      setState(() {
        _verse = verse;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Card(
        margin: const EdgeInsets.all(16),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: const Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      );
    }

    if (_verse == null) {
      return const SizedBox.shrink();
    }

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(16),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple.shade50,
                Colors.purple.shade50,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(20),
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
                      Icons.menu_book,
                      color: Colors.deepPurple.shade700,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'இன்றைய வேத வசனம்',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh, color: Colors.deepPurple.shade400),
                    iconSize: 20,
                    onPressed: _loadVerse,
                    tooltip: 'Refresh',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                _verse!.verse,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.grey.shade800,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade700,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _verse!.reference,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
