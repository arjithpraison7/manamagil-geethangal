
import json

with open('sunday_school_songs.txt', 'r', encoding='utf-8') as f:
    text = f.read()

# Split on 'பாடல்-' (with or without leading/trailing whitespace)
parts = [p.strip() for p in text.split('பாடல்-') if p.strip()]
songs = []
for part in parts:
    # The first line is the title (may be numbered), rest is lyrics
    lines = part.splitlines()
    if not lines:
        continue
    title = lines[0].strip()
    lyrics = '\n'.join(line.rstrip() for line in lines[1:]).strip()
    songs.append({
        'title': f'பாடல் {title}',
        'lyrics': lyrics
    })

with open('sunday_school_songs_cleaned.json', 'w', encoding='utf-8') as f:
    json.dump(songs, f, ensure_ascii=False, indent=2)

print(f"Extracted {len(songs)} songs to sunday_school_songs_cleaned.json")
