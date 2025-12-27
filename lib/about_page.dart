import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

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
          'About',
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
            child: Padding(
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
                      Icons.church,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'மனமகிழ் கீதங்கள்',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tamil Songs App',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.deepPurple,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.5,
                    ),
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Text(
                            'பற்றி',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'ஆலய குடும்ப ஜெபக் கூடுகையின் பயன்பாட்டிற்காக  கிறிஸ்தவ பாடல்கள் மற்றும் கீர்த்தனைகளில் அடிக்கடி உபயோகப்படுத்தப்படும்  பாடல்களைத் தெரிவுசெய்து தொகுக்கப்பட்டது.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'அப்பாடல்கள், திருவல்லிக்கேணி    C.S.I. சகல பரிசுத்தவானகளின் ஆலயத்தின் வைர விழா (2008) ஆண்டின்போது  110 பாடல்களுடன் "மனமகிழ் கீதங்கள்" என்று புத்தகமாக வெளியிடப்பட்டது.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'அந்தப் பாடல்களுடன் தற்பொழுது மேலும் 100 பாடல்கள் சேர்க்கப்பட்டுள்ளது.\nமேலும் இரங்கல் பாடல்களாக  "ஆறுதல் கீதங்கள்" என்ற தலைப்பில் பாடல்கள் தொகுக்கப்பட்டுள்ளது',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'இந்தப் பாடல்கள் அனைத்தும் திரு C. இராஜரீகம் குணசேகரன் (Retd. Under Secretary to Government ) அவர்களால்,  திரு J. அறிவு கலைச்செல்வன் (Retd. Asst. Director of Co-operative Audit) அவர்களின் உதவியுடன் தொகுக்கப்படுள்ளது.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'திருமதி ஹில்டா இராஜரீகம் அவர்களால்   "90 ஞாயிறு பள்ளி பாடல்கள்" தொகுக்கப்பட்டு இத்துடன் சேர்க்கப்பட்டுள்ளது.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'இவைகளை "இயேசுவை போற்றும் பாடல்கள்" என்ற தலைப்பில் "செயலி" ஆக  வெளியிடப்பட்டுள்ளது',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
