import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ThemeSettings {
  double fontSize;
  Color textColor;
  Color backgroundColor;
  bool useGradient;
  Color gradientStartColor;
  Color gradientEndColor;
  String fontFamily;
  double lineSpacing;
  TextAlign textAlignment;

  ThemeSettings({
    this.fontSize = 20,
    this.textColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.useGradient = false,
    this.gradientStartColor = Colors.blue,
    this.gradientEndColor = Colors.purple,
    this.fontFamily = 'Default',
    this.lineSpacing = 1.5,
    this.textAlignment = TextAlign.center,
  });

  Map<String, dynamic> toJson() => {
    'fontSize': fontSize,
    'textColor': textColor.value,
    'backgroundColor': backgroundColor.value,
    'useGradient': useGradient,
    'gradientStartColor': gradientStartColor.value,
    'gradientEndColor': gradientEndColor.value,
    'fontFamily': fontFamily,
    'lineSpacing': lineSpacing,
    'textAlignment': textAlignment.index,
  };

  factory ThemeSettings.fromJson(Map<String, dynamic> json) {
    return ThemeSettings(
      fontSize: json['fontSize'] ?? 20,
      textColor: Color(json['textColor'] ?? Colors.black.value),
      backgroundColor: Color(json['backgroundColor'] ?? Colors.white.value),
      useGradient: json['useGradient'] ?? false,
      gradientStartColor: Color(json['gradientStartColor'] ?? Colors.blue.value),
      gradientEndColor: Color(json['gradientEndColor'] ?? Colors.purple.value),
      fontFamily: json['fontFamily'] ?? 'Default',
      lineSpacing: json['lineSpacing'] ?? 1.5,
      textAlignment: TextAlign.values[json['textAlignment'] ?? 1],
    );
  }

  static Future<ThemeSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('themeSettings');
    if (jsonString != null) {
      return ThemeSettings.fromJson(json.decode(jsonString));
    }
    return ThemeSettings();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeSettings', json.encode(toJson()));
  }
}

class ThemePage extends StatefulWidget {
  final ThemeSettings initialSettings;
  final Function(ThemeSettings) onSettingsChanged;

  const ThemePage({
    Key? key,
    required this.initialSettings,
    required this.onSettingsChanged,
  }) : super(key: key);

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  late ThemeSettings settings;

  @override
  void initState() {
    super.initState();
    settings = ThemeSettings(
      fontSize: widget.initialSettings.fontSize,
      textColor: widget.initialSettings.textColor,
      backgroundColor: widget.initialSettings.backgroundColor,
      useGradient: widget.initialSettings.useGradient,
      gradientStartColor: widget.initialSettings.gradientStartColor,
      gradientEndColor: widget.initialSettings.gradientEndColor,
      fontFamily: widget.initialSettings.fontFamily,
      lineSpacing: widget.initialSettings.lineSpacing,
      textAlignment: widget.initialSettings.textAlignment,
    );
  }

  void _updateSettings() {
    settings.save();
    widget.onSettingsChanged(settings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset to Default',
            onPressed: () {
              setState(() {
                settings = ThemeSettings();
                _updateSettings();
              });
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Font Size
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Font Size',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          min: 12,
                          max: 48,
                          value: settings.fontSize,
                          onChanged: (v) {
                            setState(() {
                              settings.fontSize = v;
                              _updateSettings();
                            });
                          },
                        ),
                      ),
                      Text('${settings.fontSize.toInt()}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Text Color
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Text Color',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      _colorButton(Colors.black, settings.textColor, (c) {
                        setState(() {
                          settings.textColor = c;
                          _updateSettings();
                        });
                      }),
                      _colorButton(Colors.white, settings.textColor, (c) {
                        setState(() {
                          settings.textColor = c;
                          _updateSettings();
                        });
                      }),
                      _colorButton(Colors.red, settings.textColor, (c) {
                        setState(() {
                          settings.textColor = c;
                          _updateSettings();
                        });
                      }),
                      _colorButton(Colors.blue, settings.textColor, (c) {
                        setState(() {
                          settings.textColor = c;
                          _updateSettings();
                        });
                      }),
                      _colorButton(Colors.green, settings.textColor, (c) {
                        setState(() {
                          settings.textColor = c;
                          _updateSettings();
                        });
                      }),
                      _colorButton(Colors.purple, settings.textColor, (c) {
                        setState(() {
                          settings.textColor = c;
                          _updateSettings();
                        });
                      }),
                      _colorButton(Colors.orange, settings.textColor, (c) {
                        setState(() {
                          settings.textColor = c;
                          _updateSettings();
                        });
                      }),
                      _colorButton(Colors.brown, settings.textColor, (c) {
                        setState(() {
                          settings.textColor = c;
                          _updateSettings();
                        });
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Background Type
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Background Type',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SwitchListTile(
                    title: const Text('Use Gradient Background'),
                    value: settings.useGradient,
                    onChanged: (v) {
                      setState(() {
                        settings.useGradient = v;
                        _updateSettings();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Solid Background Color
          if (!settings.useGradient)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Background Color',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        _colorButton(Colors.white, settings.backgroundColor, (c) {
                          setState(() {
                            settings.backgroundColor = c;
                            _updateSettings();
                          });
                        }),
                        _colorButton(Colors.black, settings.backgroundColor, (c) {
                          setState(() {
                            settings.backgroundColor = c;
                            _updateSettings();
                          });
                        }),
                        _colorButton(Colors.yellow[100]!, settings.backgroundColor, (c) {
                          setState(() {
                            settings.backgroundColor = c;
                            _updateSettings();
                          });
                        }),
                        _colorButton(Colors.grey[200]!, settings.backgroundColor, (c) {
                          setState(() {
                            settings.backgroundColor = c;
                            _updateSettings();
                          });
                        }),
                        _colorButton(Colors.blue[50]!, settings.backgroundColor, (c) {
                          setState(() {
                            settings.backgroundColor = c;
                            _updateSettings();
                          });
                        }),
                        _colorButton(Colors.purple[50]!, settings.backgroundColor, (c) {
                          setState(() {
                            settings.backgroundColor = c;
                            _updateSettings();
                          });
                        }),
                        _colorButton(Colors.green[50]!, settings.backgroundColor, (c) {
                          setState(() {
                            settings.backgroundColor = c;
                            _updateSettings();
                          });
                        }),
                        _colorButton(Colors.pink[50]!, settings.backgroundColor, (c) {
                          setState(() {
                            settings.backgroundColor = c;
                            _updateSettings();
                          });
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Gradient Colors
          if (settings.useGradient) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gradient Start Color',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        _colorButton(Colors.blue, settings.gradientStartColor, (c) {
                          setState(() {
                            settings.gradientStartColor = c;
                            _updateSettings();
                          });
                        }),
                        _colorButton(Colors.purple, settings.gradientStartColor, (c) {
                          setState(() {
                            settings.gradientStartColor = c;
                            _updateSettings();
                          });
                        }),
                        _colorButton(Colors.pink, settings.gradientStartColor, (c) {
                          setState(() {
                            settings.gradientStartColor = c;
                            _updateSettings();
                          });
                        }),
                        _colorButton(Colors.orange, settings.gradientStartColor, (c) {
                          setState(() {
                            settings.gradientStartColor = c;
                            _updateSettings();
                          });
                        }),
                        _colorButton(Colors.teal, settings.gradientStartColor, (c) {
                          setState(() {
                            settings.gradientStartColor = c;
                            _updateSettings();
                          });
                        }),
                        _colorButton(Colors.indigo, settings.gradientStartColor, (c) {
                          setState(() {
                            settings.gradientStartColor = c;
                            _updateSettings();
                          });
                        }),
                        _colorButton(Colors.cyan, settings.gradientStartColor, (c) {
                          setState(() {
                            settings.gradientStartColor = c;
                            _updateSettings();
                          });
                        }),
                        _colorButton(Colors.lime, settings.gradientStartColor, (c) {
                          setState(() {
                            settings.gradientStartColor = c;
                            _updateSettings();
                          });
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gradient End Color',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        _colorButton(Colors.purple, settings.gradientEndColor, (c) {
                          setState(() {
                            settings.gradientEndColor = c;
                            _updateSettings();
                          });
                        }),
                        _colorButton(Colors.blue, settings.gradientEndColor, (c) {
                          setState(() {
                            settings.gradientEndColor = c;
                            _updateSettings();
                          });
                        }),
                        _colorButton(Colors.pink, settings.gradientEndColor, (c) {
                          setState(() {
                            settings.gradientEndColor = c;
                            _updateSettings();
                          });
                        }),
                        _colorButton(Colors.orange, settings.gradientEndColor, (c) {
                          setState(() {
                            settings.gradientEndColor = c;
                            _updateSettings();
                          });
                        }),
                        _colorButton(Colors.teal, settings.gradientEndColor, (c) {
                          setState(() {
                            settings.gradientEndColor = c;
                            _updateSettings();
                          });
                        }),
                        _colorButton(Colors.indigo, settings.gradientEndColor, (c) {
                          setState(() {
                            settings.gradientEndColor = c;
                            _updateSettings();
                          });
                        }),
                        _colorButton(Colors.cyan, settings.gradientEndColor, (c) {
                          setState(() {
                            settings.gradientEndColor = c;
                            _updateSettings();
                          });
                        }),
                        _colorButton(Colors.lime, settings.gradientEndColor, (c) {
                          setState(() {
                            settings.gradientEndColor = c;
                            _updateSettings();
                          });
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),

          // Line Spacing
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Line Spacing',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          min: 1.0,
                          max: 3.0,
                          value: settings.lineSpacing,
                          divisions: 20,
                          onChanged: (v) {
                            setState(() {
                              settings.lineSpacing = v;
                              _updateSettings();
                            });
                          },
                        ),
                      ),
                      Text(settings.lineSpacing.toStringAsFixed(1)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Text Alignment
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Text Alignment',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _alignmentButton(Icons.format_align_left, TextAlign.left),
                      _alignmentButton(Icons.format_align_center, TextAlign.center),
                      _alignmentButton(Icons.format_align_right, TextAlign.right),
                      _alignmentButton(Icons.format_align_justify, TextAlign.justify),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Preview
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Preview',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: settings.useGradient ? null : settings.backgroundColor,
                      gradient: settings.useGradient
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                settings.gradientStartColor,
                                settings.gradientEndColor,
                              ],
                            )
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Text(
                        'இயேசு எந்தன் வாழ்வின் பெலனானார்\nஎன்னை நேசித்து சிலுவையில் மரித்தார்',
                        style: TextStyle(
                          fontSize: settings.fontSize,
                          color: settings.textColor,
                          height: settings.lineSpacing,
                        ),
                        textAlign: settings.textAlignment,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorButton(Color color, Color selected, Function(Color) onTap) {
    final isSelected = color.value == selected.value;
    return GestureDetector(
      onTap: () => onTap(color),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
      ),
    );
  }

  Widget _alignmentButton(IconData icon, TextAlign alignment) {
    final isSelected = settings.textAlignment == alignment;
    return IconButton(
      icon: Icon(icon),
      color: isSelected ? Colors.blue : Colors.grey,
      iconSize: 32,
      onPressed: () {
        setState(() {
          settings.textAlignment = alignment;
          _updateSettings();
        });
      },
    );
  }
}
