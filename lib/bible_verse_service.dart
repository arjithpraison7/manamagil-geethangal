import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BibleVerse {
  final String verse;
  final String reference;
  final String date;

  BibleVerse({
    required this.verse,
    required this.reference,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'verse': verse,
    'reference': reference,
    'date': date,
  };

  factory BibleVerse.fromJson(Map<String, dynamic> json) {
    return BibleVerse(
      verse: json['verse'] ?? '',
      reference: json['reference'] ?? '',
      date: json['date'] ?? '',
    );
  }
}

class BibleVerseService {
  static const String _cacheKey = 'daily_bible_verse';
  static const String _cacheDateKey = 'bible_verse_date';

  // Fallback verses in Tamil when offline
  static final List<Map<String, String>> _fallbackVerses = [
    {
      'verse': 'கர்த்தர் என் மேய்ப்பராயிருக்கிறார்; எனக்குக் குறைவு இல்லை.',
      'reference': 'சங்கீதம் 23:1'
    },
    {
      'verse': 'கர்த்தரை நோக்கிக் காத்திருக்கிறவர்கள் புதுப்பெலனடைவார்கள்.',
      'reference': 'ஏசாயா 40:31'
    },
    {
      'verse': 'தேவன் அன்பு; அன்பிலிருக்கிறவன் தேவனிலே நிலைத்திருக்கிறான்.',
      'reference': '1 யோவான் 4:16'
    },
    {
      'verse': 'உங்கள் கவலைகளையெல்லாம் அவர்மேல் வைத்துவிடுங்கள், அவர் உங்களைக் கவனிக்கிறார்.',
      'reference': '1 பேதுரு 5:7'
    },
    {
      'verse': 'நான் உங்களுக்குச் சமாதானத்தை வைத்துப்போகிறேன்; என்னுடைய சமாதானத்தையே உங்களுக்குக் கொடுக்கிறேன்.',
      'reference': 'யோவான் 14:27'
    },
    {
      'verse': 'கர்த்தருடைய நாமத்தைத் தொழுதுகொள்ளுகிற யாவரும் இரட்சிக்கப்படுவார்கள்.',
      'reference': 'ரோமர் 10:13'
    },
    {
      'verse': 'தேவன் நம்மோடேகூட இருக்கிறாரானால், நமக்கு விரோதமாய் யார் இருக்கமாட்டார்கள்?',
      'reference': 'ரோமர் 8:31'
    },
    {
      'verse': 'நான் உங்களை விட்டுவிடுவதுமில்லை, உங்களைக் கைவிடுவதுமில்லை.',
      'reference': 'எபிரெயர் 13:5'
    },
    {
      'verse': 'கர்த்தர் நல்லவர்; அவருடைய கிருபை என்றைக்கும் உள்ளது.',
      'reference': 'சங்கீதம் 100:5'
    },
    {
      'verse': 'எல்லாவற்றையும் செய்ய எனக்குப் பெலன் அளிக்கிற கிறிஸ்துவினாலே எல்லாவற்றையும் செய்ய எனக்குக் கூடும்.',
      'reference': 'பிலிப்பியர் 4:13'
    },
    {
      'verse': 'தேவன் எங்களுக்குக் கொடுத்தது பயத்தின் ஆவியல்ல, பலத்தின் ஆவியும், அன்பின் ஆவியும், தெளிந்த புத்தியின் ஆவியுமே.',
      'reference': '2 தீமோத்தேயு 1:7'
    },
    {
      'verse': 'நீதிமானின் ஜெபம் மிகுந்த பெலன் பெற்றது.',
      'reference': 'யாக்கோபு 5:16'
    },
    {
      'verse': 'கர்த்தரை நம்புகிறவன் பாதுகாப்பாயிருப்பான்.',
      'reference': 'நீதிமொழிகள் 29:25'
    },
    {
      'verse': 'அவர் உங்கள் பாதங்களைத் தள்ளாடவொட்டார்; உங்களைக் காக்கிறவர் தூங்குவதில்லை.',
      'reference': 'சங்கீதம் 121:3'
    },
    {
      'verse': 'என் நுகம் மெதுவாயும், என் சுமை இலேசாயும் இருக்கும்.',
      'reference': 'மத்தேயு 11:30'
    },
  ];

  static Future<BibleVerse> getDailyVerse() async {
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month}-${today.day}';
    
    // Check if we have cached verse for today
    final cachedVerse = await _getCachedVerse();
    if (cachedVerse != null) {
      final prefs = await SharedPreferences.getInstance();
      final cachedDate = prefs.getString(_cacheDateKey);
      if (cachedDate == todayStr) {
        return cachedVerse;
      }
    }

    // For now, use local Tamil verses
    // TODO: Replace with Tamil Bible API when available
    final fallbackVerse = _getFallbackVerse(today);
    await _cacheVerse(fallbackVerse, todayStr);
    return fallbackVerse;
  }

  static Future<BibleVerse?> _fetchFromAPI() async {
    try {
      // Using Bible API (you can replace with Tamil Bible API if available)
      final response = await http.get(
        Uri.parse('https://beta.ourmanna.com/api/v1/get/?format=json'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Note: This API returns English verses. 
        // Replace with a Tamil Bible API when available
        return BibleVerse(
          verse: data['verse']['details']['text'] ?? '',
          reference: data['verse']['details']['reference'] ?? '',
          date: DateTime.now().toString(),
        );
      }
    } catch (e) {
      print('API fetch error: $e');
    }
    return null;
  }

  static BibleVerse _getFallbackVerse(DateTime date) {
    // Use day of year to cycle through verses
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    final verseData = _fallbackVerses[dayOfYear % _fallbackVerses.length];
    
    return BibleVerse(
      verse: verseData['verse']!,
      reference: verseData['reference']!,
      date: date.toString(),
    );
  }

  static Future<void> _cacheVerse(BibleVerse verse, String date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, json.encode(verse.toJson()));
    await prefs.setString(_cacheDateKey, date);
  }

  static Future<BibleVerse?> _getCachedVerse() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_cacheKey);
    if (cachedData != null) {
      try {
        return BibleVerse.fromJson(json.decode(cachedData));
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
